package haxe.ui.extended;

class Util {
    
}

/**
 * Cli util for coloring the console. Vars that start with b are BOLD.
 * Don't forget to use the reset after coloring to avoid coloring the whole string.
 */
class Cli{
	public static final red =  "\033[31m";
	public static final green =  "\033[32m";
	public static final yellow =  "\033[33m";
	public static final bred =  "\033[1m\033[31m";
	public static final bgreen =  "\033[1m\033[32m";
	public static final byellow =  "\033[1m\033[33m";
	public static final reset =  "\033[0m";
}
/** the following are UBUNTU/LINUX, and MacOS ONLY terminal color codes. As of 2019 they should work in windows 10: https://stackoverflow.com/a/52063884
#define RESET   "\033[0m"
#define BLACK   "\033[30m"      
#define RED     "\033[31m"      
#define GREEN   "\033[32m"      
#define YELLOW  "\033[33m"      
#define BLUE    "\033[34m"      
#define MAGENTA "\033[35m"      
#define CYAN    "\033[36m"      
#define WHITE   "\033[37m"      
#define BOLDBLACK   "\033[1m\033[30m"      
#define BOLDRED     "\033[1m\033[31m"      
#define BOLDGREEN   "\033[1m\033[32m"      
#define BOLDYELLOW  "\033[1m\033[33m"      
#define BOLDBLUE    "\033[1m\033[34m"      
#define BOLDMAGENTA "\033[1m\033[35m"      
#define BOLDCYAN    "\033[1m\033[36m"      
#define BOLDWHITE   "\033[1m\033[37m"      
**/