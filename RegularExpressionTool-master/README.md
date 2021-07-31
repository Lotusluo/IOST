# RegularExpressionTool
iOS 开发中常用正则表达式
/**
 * 非空判断
 
 * @param str 传入判断字符串
 * @return YES?NO
 */
+ (BOOL) validateStringNilOrEmpty:(NSString *)str;

/**
 * 字符串长度验证
 
 * @param str 传入判断字符串
 * @param maxLength 最大长度
 * @param minLength 最小长度
 * @return YES?NO
 */
+ (BOOL ) validateParaStringLength:(NSString *)str MaxLength:(NSInteger) maxLength MinLength:(NSInteger) minLength;

/**
 * 身份证正则表达式
 
 * @param identityCard 身份证
 * @return YES?NO
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;


/**
 * 首元素为字母

 * @param str 传入判断在字符串
 * @return YES?NO
 */
+ (BOOL)validateMatchLetter:(NSString *)str;


/**
 * 电子邮箱正则表达式

 * @param email 邮箱
 * @return YES?NO
 */
+ (BOOL)validateEmail:(NSString *)email;


/**
 * 手机号码正则表达式

 * @param mobileNum 手机号
 * @return YES?NO
 */
+ (BOOL)validateMobileNumber:(NSString *)mobileNum;


/**
 *网址链接正则表达式

 * @param url 传入判断字符串
 * @return YES?NO
 */
+ (BOOL)validateHttpRequestUrl:(NSString *)url;

/**
 * 护照正则表达式

 * @param number 护照号码
 * @return YES?NO
 */
+ (BOOL)validatePassportNumber:(NSString *)number;

/**
 * 用户名正则表达
 
 * @para userName 用户名
 * @return YES?NO
 */
+ (BOOL) validateUserName:(NSString *) userName;


/**
 * 密码正则表达
 
 * @para password 密码
 * @return YES?NO
 */
+ (BOOL) validatePassword:(NSString *)password;

/**
 * 密码强度正则表达
 
 * @para password 密码
 * @return YES?NO
 */
+ (BOOL) validatePasswordStrength:(NSString *)password;

/**
 *  验证码正则表达式
 *  @param verifyCode 验证码
 *  @return YES/NO
 */
+ (BOOL) validateVerifyCode:(NSString *)verifyCode;

/**
 * 昵称正则表达
 
 * @para nickName 昵称
 * @return YES?NO
 */
+ (BOOL) validateNickName:(NSString *)nickName;

/**
 * 银行卡号正则表达
 
 * @para bankCardNumber 银行卡号
 * @return YES?NO
 */
+ (BOOL) validateBankCardNumber:(NSString *)bankCardNumber;

/**
 *  验证银行卡后四位
 
 *  @param bankCardNumber 银行卡后四位
 *  @return YES/NO
 */
+ (BOOL) validateBankCardLastNumber:(NSString *)bankCardNumber;
/**
 *  CVN验证
 *
 *  @param cvnCode CVN
 *
 *  @return YES/NO
 */
+ (BOOL) validateCVNCode:(NSString *)cvnCode;


/**
 * 车牌号码正则表达
 
 * @para number carNo
 * @return YES?NO
 */
+ (BOOL)validateCarNumber:(NSString *)number;

/**
 * 全英文正则表达式
 
 * @para target 目标
 * @return YES?NO
 */
+ (BOOL) validateEnglishLetter:(NSString *) target;

/**
 * 全大写英文正则表达式
 
 * @para target 目标
 * @return YES?NO
 */
+ (BOOL) validateCapitalEnglishLetter:(NSString *)target;

/**
 * 全小写英文正则表达式
 
 * @para target 目标
 * @return YES?NO
 */
+ (BOOL) validateLowercaseEnglishLetter:(NSString *)target;

/**
 * 英文数字正则表达式
 
 * @para target 目标
 * @return YES?NO
 */
+ (BOOL) validateNumberAndEnglishLetter:(NSString *)target;
