//
//  AppDelegate.m
//  PlcrMacosUniversal
//
//  Created by Руслан Урмеев on 19.10.2020.
//

#import "AppDelegate.h"
@import CrashReporter;

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
  PLCrashReporterSymbolicationStrategy symbolicationStrategy = PLCrashReporterSymbolicationStrategyAll;
  PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeMach
                                                                     symbolicationStrategy:symbolicationStrategy
                                                    shouldRegisterUncaughtExceptionHandler:YES];
  PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
  
  // Check if we previously crashed
  if ([crashReporter hasPendingCrashReport]){
    [self handleCrashReport:crashReporter];
    NSLog(@"Handle crash report");
  } else {
    NSLog(@"No pending crash reports");
  }
  NSError *error;
  
  // Enable the Crash Reporter
  if (![crashReporter enableCrashReporterAndReturnError: &error]) {
    NSLog(@"Warning: Could not enable crash reporter: %@", error);
  } else {
    NSLog(@"Crash reporter started");
  }
  
  // Enable catching uncaught exceptions thrown on the main thread.
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"NSApplicationCrashOnExceptions" : @YES}];
}

//
// Called to handle a pending crash report.
//
- (void) handleCrashReport:(PLCrashReporter*)crashReporter {
  NSData *crashData;
  NSError *error;
  
  // Try loading the crash report
  crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
  if (crashData == nil) {
    NSLog(@"Could not load crash report: %@", error);
    return;
  }
  
  // We could send the report from here, but we'll just print out
  // some debugging info instead
  PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
  if (report == nil) {
    NSLog(@"Could not parse crash report");
    return;
  }
  NSLog(@"Crashed on %@", report.systemInfo.timestamp);
  NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
        report.signalInfo.code, report.signalInfo.address);
  
  NSString *text = [PLCrashReportTextFormatter stringValueForCrashReport: report withTextFormat: PLCrashReportTextFormatiOS];
  NSLog(@"%@", text);
  
  // Purge the report
  [crashReporter purgePendingCrashReport];
  return;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


@end
