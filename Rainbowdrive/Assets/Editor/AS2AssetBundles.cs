using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using UnityEditor;
using UnityEngine;
using Ionic.Zip;
using Ionic.Zlib;
using Debug = UnityEngine.Debug;

public static class AS2AssetBundles
{
	// This will be written in all asset bundles you make.
	// PlayerSettings.companyName is the value specified by Edit -> Project Settings -> Player -> Company Name
	// It is better to set it there if you aren't modifying this file for any other reasons.
	static string _AssetAuthor = PlayerSettings.companyName;

	public static string AssetAuthor { get { return _AssetAuthor; } set { _AssetAuthor = value; } }

	public const string Target = ".";
	public const string Temp = "Temp/AS2AssetBundles";

	const string _MenuLocation = "Assets";
	//const string _MenuLocation = "Assets/AS2 AssetBundle"; // if that is too much clutter

	// This will be called after a successful build. Add code here if you want to automatically copy the files somewhere.
	static void _PostBuild(AssetBundleBuild[] builds, AssetBundleBuild[] builds_unchanged)
	{
		//_CopyBundle("foo", @"C:\example");

		//const string target = @"C:\Program Files (x86)\Steam\steamapps\common\Audiosurf 2\skins\example";

		//foreach (var build in builds)
		//	_CopyBundle(build, target);

		//_Copy("assets", target, ".lua", ".obj", ".mtl", ".jpg", ".png", ".txt");
	}
	static void _CopyBundle(AssetBundleBuild build, string destination)
	{
		var bundle = Target+"/"+build.assetBundleName+".";
		destination = Path.Combine(destination, build.assetBundleName+".");
		File.Copy(bundle+_Extension, destination+_Extension, true); // this is the only file actually required by Audiosurf 2
		File.Copy(bundle+_ContentsExtension, destination+_ContentsExtension, true);
	}
	static void _Copy(string src, string dest, params string[] extensions)
	{
		string cd = dest;
		foreach (var pair in _GetCopyPairs(src, dest, (src_dir, dest_dir) => !Path.GetFileName(cd = dest_dir).StartsWith(".") && cd[0] != '\0'))
		if (extensions == null || extensions.Contains(Path.GetExtension(pair.Key), StringComparer.OrdinalIgnoreCase))
		{
			Directory.CreateDirectory(cd);
			File.Copy(pair.Key, pair.Value, true);
		}
	}
	static IEnumerable<KeyValuePair<string, string>> _GetCopyPairs(string src, string dest, Func<string, string, bool> enter_dir = null)
	{
		string cd_src = src, cd_dest = dest;
		var q = new Queue<KeyValuePair<string, string>>();
		for (;;)
		{
			foreach (var file in Directory.GetFiles(cd_src))
				yield return new KeyValuePair<string, string>(file, Path.Combine(cd_dest, Path.GetFileName(file)));
			foreach (var dir in Directory.GetDirectories(cd_src))
				q.Enqueue(new KeyValuePair<string, string>(dir, Path.Combine(cd_dest, Path.GetFileName(dir))));
			for (;;)
			{
				if (q.Count == 0)
					yield break;
				var next = q.Dequeue();
				if (enter_dir == null || enter_dir(next.Key, next.Value))
				{
					cd_src = next.Key;
					cd_dest = next.Value;
					break;
				}
			}
		}
	}
	struct Dir
	{
		public readonly string Path;
		public readonly Queue<string> children;
		public Dir(string path) { Path = path; children = new Queue<string>(); }
	}

	#region Bundle Format Constants (do not change)

	static AS2AssetBundles()
	{
		if (string.IsNullOrEmpty(_AssetAuthor) || _AssetAuthor == "N/A" || _AssetAuthor == "DefaultCompany")
			_AssetAuthor = null;
	}

	const string _Version = "Audiosurf2Assets/1.0.0"; // major.nonbreaking.minor

	static readonly Platform[] _Platforms =
	{
		new Platform("Win32", BuildTarget.StandaloneWindows),
		new Platform("Win64", BuildTarget.StandaloneWindows64), // No current plans to publish a x64 build but you never know.
		new Platform("OSX",   BuildTarget.StandaloneOSX),
		new Platform("Linux", BuildTarget.StandaloneLinuxUniversal),
	};

	struct Platform
	{
		public readonly string Name;
		public readonly BuildTarget BuildTarget;
		public readonly string TempPath;
		public string TempPathOf(string bundle) { return TempPath+"/"+bundle; }
		public Platform(string name, BuildTarget build_target)
		{
			Name = name;
			BuildTarget = build_target;
			TempPath = Temp + "/" + name;
		}
	}

	const BuildAssetBundleOptions _Options = BuildAssetBundleOptions.UncompressedAssetBundle;
	const CompressionLevel _GzipCompression = CompressionLevel.BestCompression;
	static readonly Encoding _ZipAlternateEncoding = Encoding.UTF8;
	static readonly Encoding _MetadataEncoding = new UTF8Encoding(false, true);

	const string _Extension = "as2assets";
	const string _ContentsExtension = "contents.txt";
	static string _OutPath(string bundle, string extension) { return Target + "/" + bundle + "." + extension; }

	#endregion

	[MenuItem(_MenuLocation+"/Build AS2 AssetBundles")]
	public static void BuildAll()
	{
		var b = new HashSet<string>(AssetDatabase.GetAllAssetBundleNames());
		b.ExceptWith(AssetDatabase.GetUnusedAssetBundleNames());
		b.Remove("exclude");
		var bundles = b.ToArray();
		Array.Sort(bundles);
		Build(bundles);
	}

	public static void Build(params string[] bundles)
	{
		Build(Array.ConvertAll(bundles, bundle => new AssetBundleBuild
		{
			assetBundleName = bundle,
			assetNames = AssetDatabase.GetAssetPathsFromAssetBundle(bundle),
		}));
	}

	#region Build(AssetBundleBuild[]) implementation

	public static void Build(AssetBundleBuild[] builds)
	{
		try
		{
			var timer = Stopwatch.StartNew();
			const float progress_build = 0f;
			const float progress_compress = 0.5f;
			const float progress_scan = 0.5f;
			const float progress_compress_sources = 1.0f;

			string[] bundles = Array.ConvertAll(builds, b=>b.assetBundleName);
			var stamps = _TempStamps(bundles);

			// compile assets
			for (int i = 0; i < _Platforms.Length; i++)
			{
				var target = _Platforms[i];
				// BuildAssetBundles uses the same progress bar functions internally which overwrites ours
				//_BuildProgress("Building all bundles for the "+target.Name+" platform...", 0, progress_build, i, _Platforms.Length);
				Directory.CreateDirectory(target.TempPath);
				BuildPipeline.BuildAssetBundles(target.TempPath, builds, _Options, target.BuildTarget);
			}

			// check which bundles didn't change and remove them from the list
			AssetBundleBuild[] builds_unchanged;
			{
				var builds_list           = new List<AssetBundleBuild>(builds.Length);
				var builds_unchanged_list = new List<AssetBundleBuild>(builds.Length);
				var stamps_after = _TempStamps(bundles);
				for (int i = 0; i < bundles.Length; ++i)
					(Enumerable.SequenceEqual(stamps[i], stamps_after[i]) ? builds_unchanged_list : builds_list).Add(builds[i]);

				stamps = null;
				if (builds_list.Count != builds.Length)
				{
					builds = builds_list.ToArray();
					bundles = Array.ConvertAll(builds, b=>b.assetBundleName);
				}
				builds_unchanged = builds_unchanged_list.ToArray();
			}

			// merge and compress multiple platform versions into one file

			// the bundle platform variants contain a lot of mirrored data
			// because of this we want to use "solid" compression, which isn't supported by zip files
			// so instead, we will make a zip file with no compression and compress that entire file with gzip (zip.gz instead of tar.gz)
			for (int b = 0; b < bundles.Length; ++b)
			using (var zip = new ZipFile(_ZipAlternateEncoding))
			{
				var bundle = bundles[b];
				_BuildProgress("Compressing "+bundle+"...", progress_build, progress_compress, b, bundles.Length);
				zip.CompressionLevel = CompressionLevel.None;
				zip.CompressionMethod = CompressionMethod.None;

				zip.AddEntry("Name", bundle, _MetadataEncoding);
				zip.AddEntry("Version", _Version, _MetadataEncoding);
				zip.AddEntry("UnityVersion", Application.unityVersion, _MetadataEncoding);
				if (_AssetAuthor != null)
					zip.AddEntry("Author", _AssetAuthor, _MetadataEncoding);

				foreach (var platform in _Platforms)
					zip.AddFile(platform.TempPathOf(bundle), null).FileName = @"AssetBundles\"+platform.Name;

				var target = _OutPath(bundle, _Extension);
				Directory.CreateDirectory(Path.GetDirectoryName(target));
				using (var file = new GZipStream(File.Open(target, FileMode.Create), CompressionMode.Compress, _GzipCompression))
					zip.Save(file);
			}

			// generate the *.contents.txt files by reading the actual bundle files
			// it would be much easier to just dump .assetNames but this serves as a way to verify the output

			Dictionary<string, string> original_case;
			{
				// asset bundle names get lowercased. convert them back into their original case by looking them up in this dictionary
				var all = AssetDatabase.GetAllAssetPaths();
				original_case = new Dictionary<string, string>(all.Length, StringComparer.OrdinalIgnoreCase);
				foreach (var asset in all)
					original_case[asset] = asset;
				foreach (var build in builds)
				foreach (var asset in build.assetNames)
				if (!original_case.ContainsKey(asset))
					original_case[asset] = asset;
			}

			for (int b = 0; b < builds.Length; b++)
			{
				var build = builds[b];
				_BuildProgress("Verifying " + build.assetBundleName + "...", progress_compress, progress_scan, b, builds.Length);
				var contents = new HashSet<string>();
				var platform_contents = new List<KeyValuePair<string, HashSet<string>>>(_Platforms.Length);
				foreach (var platform in _Platforms)
				{
					var ab = AssetBundle.LoadFromFile(platform.TempPathOf(build.assetBundleName));
					var names = ab.GetAllAssetNames();
					ab.Unload(true);
					string true_name;
					for (int i = 0; i < names.Length; ++i)
					if (original_case.TryGetValue(names[i], out true_name))
						names[i] = true_name;
					contents.UnionWith(names);
					platform_contents.Add(_Pair(platform.Name, new HashSet<string>(names)));
				}
				platform_contents.RemoveAll(pc => { pc.Value.ExceptWith(contents); return pc.Value.Count == 0; });
				platform_contents.Insert(0, _Pair("All Platforms", contents));
				using (var sw = new StreamWriter(File.Open(_OutPath(build.assetBundleName, _ContentsExtension), FileMode.Create, FileAccess.Write, FileShare.None)))
				{
					if (platform_contents.Count == 1)
					{
						foreach (var name in platform_contents[0].Value)
							sw.WriteLine(name);
					}
					else
					{
						for (int i = 0; i < platform_contents.Count; i++)
						{
							var pc = platform_contents[i];
							sw.Write(pc.Key);
							sw.WriteLine(i == 0 ? "" : " Only");
							foreach (var name in pc.Value)
							{
								sw.Write("\t");
								sw.WriteLine(name);
							}
						}
					}
				}
			}

			_BuildProgress("Post-build...", 1, 1, 1, 1);
			_PostBuild(builds, builds_unchanged);

			Debug.Log(string.Format("AS2 AssetBundles build completed in {0}. {1} succeeded, {2} up-to-date.\nSucceeded: {3} -- Up-to-date: {4}",
				timer.Elapsed,
				bundles         .Length,
				builds_unchanged.Length,
				bundles         .Length == 0 ? "<none>" : string.Join(", ", bundles),
				builds_unchanged.Length == 0 ? "<none>" : string.Join(", ", Array.ConvertAll(builds_unchanged, b=>b.assetBundleName))  ));
		}
		finally { EditorUtility.ClearProgressBar(); }
	}

	/// <summary>Helper function to create a KeyValuePair without explicitly specifying the types.</summary>
	static KeyValuePair<K,V> _Pair<K,V>(K key, V value) { return new KeyValuePair<K,V>(key, value); }

	/// <exception cref="OperationCanceledException"></exception>
	static void _BuildProgress(string info, float min, float max, int i, int count)
	{
		if (EditorUtility.DisplayCancelableProgressBar("Building AS2 AssetBundles", info, ((float)i/(float)count) * (max-min) + min))
			throw new OperationCanceledException("The build was canceled by clicking the cancel button.");
	}

	static string[] _TempPaths(string bundle) { return Array.ConvertAll(_Platforms, p=>p.TempPathOf(bundle)); }
	static DateTime?[][] _TempStamps(string[] bundles)
	{
		return Array.ConvertAll(bundles, bundle =>
			Array.ConvertAll(_TempPaths(bundle), path =>
				File.Exists(path) ? File.GetLastWriteTime(path).ToUniversalTime() : default(DateTime?)  )  );
		// ToUniversalTime in case the system time zone changes
	}

	#endregion

	[MenuItem(_MenuLocation+"/Rebuild AS2 AssetBundles")]
	public static void Rebuild()
	{
		Clean();
		BuildAll();
	}

	[MenuItem(_MenuLocation+"/Clean AS2 AssetBundles")]
	public static void Clean()
	{
		string[] search_patterns =
		{
			"*."+_Extension,
			"*."+_ContentsExtension,
		};
		for (int i = 0;; ++i)
		try
		{
			Directory.Delete(Temp, true);
			foreach (var search_pattern in search_patterns)
			foreach (var file in Directory.GetFiles(Target, search_pattern, SearchOption.TopDirectoryOnly))
				File.Delete(file);
			break;
		}
		catch { if (i > 3) throw; Thread.Sleep((i+1)*(i+1) * 100); }
	}
}
