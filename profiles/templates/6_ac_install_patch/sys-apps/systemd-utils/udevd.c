# Calculate format=diff
diff --git a/src/udev/udevd.c b/src/udev/udevd.c
index 925fc68..cafb377 100644
--- a/src/udev/udevd.c
+++ b/src/udev/udevd.c
@@ -2041,7 +2041,7 @@ int run_udevd(int argc, char *argv[]) {
         if (arg_daemonize) {
                 pid_t pid;

-                log_info("Starting systemd-udevd version " GIT_VERSION);
+                log_info("Starting udev version " GIT_VERSION);

                 /* connect /dev/null to stdin, stdout, stderr */
                 if (log_get_max_level() < LOG_DEBUG) {
