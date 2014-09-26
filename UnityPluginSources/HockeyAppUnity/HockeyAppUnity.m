#import "HockeyAppUnity.h"
#import "Utils.h"
#import "HockeyAppUnityLogger.h"
#import "CocoaLumberjack.h"

@interface HockeyAppUnity()

@end

@implementation HockeyAppUnity

+ (void)startManagerWithIdentifier:(NSString *)appIdentifier {
  
  [self startManagerWithIdentifier:appIdentifier
                          authType:@"BITAuthenticatorIdentificationTypeAnonymous"
                            secret:nil updateManagerEnabled:YES];
}

+ (void)startManagerWithIdentifier:(NSString *)appIdentifier
                          authType:(NSString *)authType
                            secret:(NSString *)secret
              updateManagerEnabled:(BOOL)updateManagerEnabled{
  
  [self configHockeyManagerWithAppIdentifier:appIdentifier serverURL:nil];
  [self configAuthentificatorWithIdentificationType:authType secret:secret];
  [self configUpdateManagerWithUpdateManagerEnabled:updateManagerEnabled];
  [self startManager];
}

+ (void)startManagerWithIdentifier:(NSString *)appIdentifier
                          authType:(NSString *)authType
                            secret:(NSString *)secret
              updateManagerEnabled:(BOOL)updateManagerEnabled
                   autoSendEnabled:(BOOL)autoSendEnabled{
  
  [self configHockeyManagerWithAppIdentifier:appIdentifier serverURL:nil];
  [self configAuthentificatorWithIdentificationType:authType secret:secret];
  [self configUpdateManagerWithUpdateManagerEnabled:updateManagerEnabled];
  [self configCrashManagerWithAutoSendEnabled:autoSendEnabled];
  [self startManager];
}

+ (void)startManagerWithIdentifier:(NSString *)appIdentifier
                         serverURL:(NSString *)serverURL
                          authType:(NSString *)authType
                            secret:(NSString *)secret
              updateManagerEnabled:(BOOL)updateManagerEnabled
                   autoSendEnabled:(BOOL)autoSendEnabled{
  
  [self configHockeyManagerWithAppIdentifier:appIdentifier serverURL:serverURL];
  [self configAuthentificatorWithIdentificationType:authType secret:secret];
  [self configUpdateManagerWithUpdateManagerEnabled:updateManagerEnabled];
  [self configCrashManagerWithAutoSendEnabled:autoSendEnabled];
  [self startManager];
}

+ (void)configHockeyManagerWithAppIdentifier:(NSString *)appIdentifier serverURL:(NSString *)serverURL{
  
  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:appIdentifier
                                                           delegate:[HockeyAppUnityLogger sharedHockeyLogger]];
  
  if(serverURL && serverURL.length > 0) {
    [[BITHockeyManager sharedHockeyManager] setServerURL:serverURL];
  }
}

+ (void)configCrashManagerWithAutoSendEnabled:(BOOL)autoSendEnabled{
  
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:[Utils statusForAutoSendEnabled:autoSendEnabled]];
}

+ (void)configUpdateManagerWithUpdateManagerEnabled:(BOOL)updateManagerEnabled{
  
  [[BITHockeyManager sharedHockeyManager] setDisableUpdateManager:!updateManagerEnabled];
}

+ (void)configAuthentificatorWithIdentificationType:(NSString *)identificationType secret:(NSString *)secret{
  
  if(secret && secret.length > 0){
    [[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:[Utils identificationTypeForString:identificationType]];
    [[BITHockeyManager sharedHockeyManager].authenticator setAuthenticationSecret:secret];
  }
}

+ (void)startManager{
  
  [[BITHockeyManager sharedHockeyManager] startManager];
  [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

+ (void)showFeedbackListView{
  
  [[[BITHockeyManager sharedHockeyManager] feedbackManager] showFeedbackListView];
}

+ (NSString *)appVersion{
  
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleIdentifier;{
  
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (BOOL)handleOpenURL:(NSURL *) url sourceApplication:(NSString *) sourceApplication annotation:(id) annotation{
  
  if ([[BITHockeyManager sharedHockeyManager].authenticator handleOpenURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation]) {
    return YES;
  }
  return NO;
}

+ (void) sendViewLoadedMessageToUnity{
  
  NSString *gameObj = @"HockeyAppUnityIOS";
  NSString *msg = @"";
  NSString *method = @"GameViewLoaded";
  UnitySendMessage([gameObj UTF8String], [method UTF8String], [msg UTF8String]);
}

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

+ (void)leaveBreadcrumb:(NSString *)breadcrumb {
  DDLogInfo(@"%@",breadcrumb);
}

+ (void)logError:(NSString *)error {
  DDLogError(@"%@",error);
}

@end
