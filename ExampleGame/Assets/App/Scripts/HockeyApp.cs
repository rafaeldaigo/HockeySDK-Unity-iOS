using UnityEngine;
using System.Collections;

namespace CrashReporter
{
	public class HockeyApp : MonoBehaviour 
	{
		#if UNITY_IPHONE
		//TODO: REPLACEME
		// Remember to replace the AppId in the PostProcessBuild_HA (it is only needed if authenticating with browser)
		// Only the first string is needed, others are optional.
		static readonly string appID = "8158cc511d6a4d51c7d1d29689941987"; // Your hockey app id
		static readonly string secret = ""; // Your hockey app secret
		static readonly string authenticationType = ""; // Your auth type. From http://support.hockeyapp.net/kb/client-integration-ios-mac-os-x/authenticating-users-on-ios
		static readonly string serverURL = ""; // Your custom server url
		static readonly bool autoUpload = false; // If true, will upload crashes without asking the user.
		static readonly bool exceptionLogging = true; // If true, will to log handled exceptions.
		static readonly bool updateManager = false; // If true, will show a popup if there is a new version
		#endif

		void Start()
		{
			#if UNITY_IPHONE
			GameObject hockeyAppManager = new GameObject("HockeyAppUnityIOS");
			HockeyAppIOS hockeyAppIOS = hockeyAppManager.AddComponent<HockeyAppIOS>();
			hockeyAppIOS.appID = appID;
			hockeyAppIOS.secret = secret;
			hockeyAppIOS.authenticationType = authenticationType;
			hockeyAppIOS.serverURL = serverURL;
			hockeyAppIOS.autoUpload = autoUpload;
			hockeyAppIOS.exceptionLogging = exceptionLogging;
			hockeyAppIOS.updateManager = updateManager;
			#endif
		}
	}
}
