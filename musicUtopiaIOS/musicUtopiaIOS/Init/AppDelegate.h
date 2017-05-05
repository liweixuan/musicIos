/*
 * 文件：App主入口文件
 * 描述：App应用的主入口文件，所有需要进行启动应用时进行的配置，验证等操作全部在该文件中进行处理
 *      并且创建了初始化扩展文件，init/AppDeletegate+Expaned，所有具体代码处理方法可在该文件中进行扩展，并在本文件中进行调用
 *      例如：版本验证，三方SDK植入并初始化，主界面初始化等操作
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

