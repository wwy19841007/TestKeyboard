/** 
* @file    hci_hwr.h 
* @brief   HCI_HWR SDK ����ͷ�ļ�  
*/  

#ifndef _hci_hwr_header_
#define _hci_hwr_header_

#include "hci_sys.h"

#ifdef __cplusplus
extern "C"
{
#endif

	/** @defgroup HCI_HWR ����HWR����API */
	/* @{ */

	//////////////////////////////////////////////////////////////////////////
	// ��������

#define HWR_CAP_PROP_MODE		"mode"		///< HWR�������������ƣ�ʶ��ģʽ��ֵ������ʶ��(letter), ����ʶ��(freewrite)
#define HWR_CAP_PROP_LANG		"lang"		///< HWR�������������ƣ�����
#define HWR_CAP_PROP_DOMAIN		"domain"	///< HWR�������������ƣ�����

	//////////////////////////////////////////////////////////////////////////
	// ���ݽṹ����

	/**
	* @brief	HWRʶ���ѡ�����Ŀ
	*/
	typedef struct _tag_HWR_RECOG_RESULT_ITEM 
	{
		/// ÿ���ֶ�Ӧ�ıʼ�λ�ã�pusPointOffset[0]��ʾ��һ���ֵĿ�ʼλ��(���������ͱ���ʶ��ʱ��ֵ��Ч)
		unsigned short *	pusPointOffset;

		/// �ʼ�λ�õĸ�����Ҳ����������ж��ٸ���(���������ͱ���ʶ��ʱ��ֵ��Ч)
		unsigned int		uiOffsetCount;

		/// ��ѡ����ַ�����UTF-8���룬��'\0'����(����ʶ��ʱ��ֵ��һ���ֽ�(����unsigned char����)��ʾ����ʶ����������ֵ����@ref gestures_list )
		char *				pszResult;
	} HWR_RECOG_RESULT_ITEM;


	/**
	*	@brief	HWRʶ�����ķ��ؽ��
	*/
	typedef struct _tag_HWR_RECOG_RESULT 
	{  
		/// ʶ���ѡ����б�
		HWR_RECOG_RESULT_ITEM *	psResultItemList;

		/// ʶ���ѡ�������Ŀ
		unsigned int		uiResultItemCount;
	} HWR_RECOG_RESULT;

	/**
	* @brief	�ϴ���HWRȷ�Ͻ����Ϣ
	*/
	typedef struct _tag_HWR_CONFIRM_ITEM
	{
		/// ȷ�ϵ�ʶ�������ݣ���'\0'����(����ʶ��ʱ���봫����Ƶ�����ֵ��ͬ����'\0'����)
		char * pszText;
	} HWR_CONFIRM_ITEM;

	/**
	* @brief	ƴ����Ŀ
	*/
	typedef struct _tag_PINYIN_RESULT_ITEM
	{
		/// ƴ������UTF-8���룬��'\0'����
		char * pszPinyin;
	} PINYIN_RESULT_ITEM;

	/**
	* @brief	��ѯƴ�������ķ��ؽ������Ϊ�����֣���������������Ŀ
	*/
	typedef struct _tag_PINYIN_RESULT
	{
		/// ƴ������б�
		PINYIN_RESULT_ITEM * pItemList;

		/// ƴ���������Ŀ
		unsigned int uiItemCount;
	} PINYIN_RESULT;

	/**
	* @brief	�������Ŀ
	*/
	typedef struct _tag_ASSOCIATE_WORDS_RESULT_ITEM
	{
		/// ����ʣ�UTF-8���룬��'\0'���������������������ַ���
		char * pszWord;
	} ASSOCIATE_WORDS_RESULT_ITEM;

	/**
	* @brief	��ѯ����ʺ����ķ��ؽ��
	*/
	typedef struct _tag_ASSOCIATE_WORDS_RESULT
	{
		/// ����ʽ���б�
		ASSOCIATE_WORDS_RESULT_ITEM * pItemList;

		/// ����ʽ������Ŀ
		unsigned int uiItemCount;
	} ASSOCIATE_WORDS_RESULT;

	/**
	* @brief  ���ͽ����Ŀ
	*/
	typedef struct _tage_PEN_SCRIPT_RESULT_ITEM
	{
		/// λͼ���ݱ�־λ
		short * psPageImg;

		/// λͼ������
		int x;

		/// λͼ������
		int y;

		/// λͼ���
		int nWidth;

		/// λͼ�߶�
		int nHeight;

		/// λͼ��ɫ
		unsigned long unPenColor; 
	} PEN_SCRIPT_RESULT_ITEM;

	/**
	* @brief  ���ͽ����Ŀ
	*/
	typedef struct _tage_PEN_SCRIPT_RESULT
	{
		/// ���ͽ���б�
		PEN_SCRIPT_RESULT_ITEM * pItemList;

		/// ���ͽ������Ŀ
		unsigned int uiItemCount;
	} PEN_SCRIPT_RESULT;

	//////////////////////////////////////////////////////////////////////////
	// �ӿ�API��������

	/**  
	* @brief	����HWR���� ��ʼ��
	* @param	pszConfig		��ʼ�����ô�,ASCII�ַ�������'\0'����
	* @return
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_SYS_NOT_INIT</td><td>HCI SYS ��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ALREADY_INIT</td><td>HWR�ظ���ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_INVALID</td><td>������Ƿ�</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_DATAPATH_MISSING</td><td>��������initCapkeysȴû��dataPath</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_CAPKEY_NOT_MATCH</td><td>����Ĳ���HWR������KEY</td></tr>
	*		<tr><td>@ref HCI_ERR_CAPKEY_NOT_FOUND</td><td>���������keyδ�ҵ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_INIT_FAILED</td><td>���������ʼ��ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOCAL_LIB_MISSING</td><td>��������ȱ���ֵ�</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*	</table>
	*
	* @par ���ô����壺
	* ���ô�����"�ֶ�=ֵ"����ʽ������һ���ַ���������ֶ�֮����','�������ֶ������ִ�Сд�������ô����ڱ���ʶ����ֵ���������á�
	* ������Ҫʹ�ñ��������������ô����Դ�NULL����""��
	* @n@n
	*	<table>
	*		<tr>
	*			<td><b>�ֶ�</b></td>
	*			<td><b>ȡֵ��ʾ��</b></td>
	*			<td><b>ȱʡֵ</b></td>
	*			<td><b>����</b></td>
	*			<td><b>��ϸ˵��</b></td>
	*		</tr>
	*		<tr>
	*			<td>dataPath</td>
	*			<td>opt/myapp/hwr_data/</td>
	*			<td>��</td>
	*			<td>��дʶ�𱾵���Դ����·��</td>
	*			<td>�����ʹ�ñ�����дʶ�����������Բ�������</td>
	*		</tr>
	*		<tr>
	*			<td>initCapKeys</td>
	*			<td>hwr.local.freestylus</td>
	*			<td>��</td>
	*			<td>��ʼ������ı�������</td>
	*			<td>���������';'���������Դ�����ƶ�����key�������ʹ�ñ���ʶ�����������Բ�������</td>
	*		</tr>
	*		<tr>
	*			<td>fileFlag</td>
	*			<td>none, android_so</td>
	*			<td>none</td>
	*			<td>��ȡ�����ļ�����������</td>
	*			<td>�μ������ע��</td>
	*		</tr>
	*		<tr>
	*			<td>associateModel</td>
	*			<td>multi, single</td>
	*			<td>multi</td>
	*			<td>�����������Ƕ��ֻ��ǵ��֣�������ֻ֧���������룬Ӣ���������</td>
	*			<td>�������Ϊmulti���򲻻���������ʵĳ��Ƚ������ơ��������Ϊsingle�����ʾ�޶�����ʷ��ؽ��Ϊ���֡�</td>
	*		</tr>
	*	</table>
	*
	*  <b>Android��������</b>
	*  @n
	*  ��fileFlagΪandroid_soʱ�����ر�����Դ�ļ�(�ֵ�������)ʱ�Ὣ�����Ŀ��ļ�������Ϊso�ļ������м��ء�
	*  ���磬��ʹ�õĿ�Ϊfile.datʱ����ʵ�ʴ򿪵��ļ���Ϊlibfile.dat.so��������Androidϵͳ�£�
	*  �����߿��԰��մ˹��򽫱�����Դ������, ����libsĿ¼�´����apk���ڰ�װ����Щ��Դ�ļ�
	*  �ͻ������/data/data/����/libĿ¼�¡������ֱ�ӽ�dataPath������ָΪ��Ŀ¼���ɡ�
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_init(
		_MUST_ _IN_ const char * pszConfig
		);

	/**  
	* @brief	��ʼ�Ự
	* @param	pszConfig		�Ự���ô�,ASCII�ַ�������'\0'����
	* @param	pnSessionId		�ɹ�ʱ���ػỰID
	* @return
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_CAPKEY_MISSING</td><td>ȱ�ٱ����capKey������</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_INVALID</td><td>���ô��е�ֵ���Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_CAPKEY_NOT_MATCH</td><td>����Ĳ���HWR������KEY</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_UNSUPPORT</td><td>��֧�ִ��������</td></tr>
	*		<tr><td>@ref HCI_ERR_TOO_MANY_SESSION</td><td>������Session������������(256)</td></tr>
	*		<tr><td>@ref HCI_ERR_CAPKEY_NOT_FOUND</td><td>���������keyδ�ҵ�</td></tr>
	*		<tr><td>@ref HCI_ERR_URL_MISSING</td><td>δ�ҵ���Ч���Ʒ����ַ</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_SESSION_START_FAILED</td><td>�������������Ựʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOCAL_LIB_MISSING</td><td>��������ȱ���ֵ�</td></tr>
	*		<tr><td>@ref HCI_ERR_LOAD_FUNCTION_FROM_DLL</td><td>Ҫ�����ģ�鲻���ڣ�������Ҫ�Ĺ����ڸ�ģ�鲻����</td></tr>
	*	</table>
	*
	* @par ���ô����壺
	* ���ô�����"�ֶ�=ֵ"����ʽ������һ���ַ���������ֶ�֮����','�������ֶ������ִ�Сд��
	* @n@n
	*	<table>
	*		<tr>
	*			<td><b>�ֶ�</b></td>
	*			<td><b>ȡֵ��ʾ��</b></td>
	*			<td><b>ȱʡֵ</b></td>
	*			<td><b>����</b></td>
	*			<td><b>��ϸ˵��</b></td>
	*		</tr>
	*		<tr>
	*			<td>capKey</td>
	*			<td>hwr.cloud.freewrite</td>
	*			<td>��</td>
	*			<td>��дʶ������key</td>
	*			<td>�μ� @ref hci_hwr_page ��ÿ��sessionֻ�ܶ���һ�����������ҹ����в��ܸı䡣</td>
	*		</tr>
	*		<tr>
	*			<td>realtime</td>
	*			<td>no, yes</td>
	*			<td>no</td>
	*			<td>�Ƿ�����ʵʱʶ�𣬽����ض�����д����֧��</td>
	*			<td>�μ� hci_hwr_recog() ������ע��</td>
	*		</tr>
	*	</table>
	* @n@n
	* ���⣬���ﻹ���Դ���ʶ���������(����subLang)����ΪĬ��������μ� hci_hwr_recog() ��
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_session_start(
		_MUST_ _IN_ const char * pszConfig,
		_MUST_ _OUT_ int * pnSessionId
		);

	/**  
	* @brief	ʶ����
	* @param	nSessionId			�ỰID
	* @param	psStrokingData		Ҫʶ��ıʼ����ݣ����ɴ���64KB���������������ɣ�ÿ���������ʽΪ��x��y����x �� y ����short���ͣ�
	*								��Чֵ��0~32767���������ָ�����������(-1��0)��һ���ʻ������ı�ǣ�(-1, -1) �Ǳʼ������ı��
	* @param	uiStrokingDataLen	Ҫʶ��ıʼ����ݳ���, �ֽ�Ϊ��λ
	* @param	pszConfig			ʶ��������ô�,ASCII�ַ�������'\0'��������ΪNULL
	* @param	psHwrRecogResult	ʶ������ʹ����ɺ���ʹ�� hci_hwr_free_recog_result() ���������ͷ�
	* @return
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_DATA_SIZE_TOO_LARGE</td><td>����ĵ��������ɴ��������</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_INVALID</td><td>���ô��е�ֵ���Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_SESSION_INVALID</td><td>�����Session�Ƿ�</td></tr>
	*		<tr><td>@ref HCI_ERR_SYS_NOT_INIT</td><td>HCI SYSδ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_CAPKEY_NOT_FOUND</td><td>���������keyδ�ҵ�</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_UNSUPPORT</td><td>��֧�ִ��������</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_FAILED</td><td>��������ʶ��ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_URL_MISSING</td><td>δ�ҵ���Ч���Ʒ����ַ</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_CONNECT_FAILED</td><td>���ӷ�����ʧ�ܣ�����������Ӧ</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_TIMEOUT</td><td>���������ʳ�ʱ</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_DATA_INVALID</td><td>���������ص����ݸ�ʽ����ȷ</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_RESPONSE_FAILED</td><td>����������ʶ��ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_UNSUPPORT</td><td>�ݲ�֧��</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_CONFIG_SUBLANG_MISSING</td><td>����������ʱδ����subLang����</td></tr>
	*	</table>
	*
	* @par ���ô����壺
	* ���ô�����"�ֶ�=ֵ"����ʽ������һ���ַ���������ֶ�֮����','�������ֶ������ִ�Сд��
	* @n@n
	*	�������ã���������أ��������е�������֧�֣��μ� @ref hci_hwr_page ������ʹ���Ͽ���ѯ��ͨ������˾��
	*	<table>
	*		<tr>
	*			<td><b>�ֶ�</b></td>
	*			<td><b>ȡֵ��ʾ��</b></td>
	*			<td><b>ȱʡֵ</b></td>
	*			<td><b>����</b></td>
	*			<td><b>��ϸ˵��</b></td>
	*		</tr>
	*		<tr>
	*			<td>candNum</td>
	*			<td>1-10</td>
	*			<td>10</td>
	*			<td>ʶ���ѡ�������</td>
	*			<td></td>
	*		</tr>
	*		<tr>
	*			<td>recogRange</td>
	*			<td>gb, gbk, big5, alphabet, number, punctuation, all</td>
	*			<td>���������������б��и���</td>
	*			<td>ʶ��Χ</td>
	*			<td>lower: СдӢ����ĸ<br/>
	*              upper: ��дӢ����ĸ<br/>
	*				alphabet: Ӣ����ĸ���ܹ�52��Сд��ĸ<br/>
	*				number�����֣�0~9ʮ������<br/>
	*              alnum: ���ֺ�Ӣ����ĸ<br/>
	*				symbol:<br/>
	*				sympun:<br/>
	*				punctuation:ͬpunct<br/>
	*              punct: �����ţ�43��<br/>
	*              gb: ����һ�������֣��ܹ�6763������<br/>
	*				gbk: GBKȫ������(����ƫ�Բ���)���ܹ�21003������<br/>
	*				gb18030: GB18030�����к��֣���27585��<br/>
	*				big5_5401: Big5һ�����֣��ܹ�5401����<br/>
	*				big5: Big5���֣��ܹ�13060����<br/>
	*				hkscs: ��������ַ�������4026��<br/>
	*				all(��������): �����ַ�������gb��gbk��big5, alphabet, number, punctuation<br/>
	*				all(Ӣ������): alphabet, number, punctuation<br/>
	*				all(��������): Ϊ����֧�ַ�Χ�ļ��ϡ�
	*				punctuation: ͬ punct<br/>
	*				katakana: ����Ƭ����<br/>
	*				hiragana������ƽ����<br/>
	*				kanji_jis0208: JIS X 0208�е��ձ�����<br/>
	*				kanji_cp932: CP932�е��ձ�����<br/>
	*				kanji_jis0213: JIS0213�е��ձ�����<br/>
	*				hanja: ���ĺ���<br/>
	*				hangul: ��������<br/>
	*				hangul_basic: ������������<br/>
	*				thai: ̩������<br/>
	*				hindi: ӡ��������<br/>
	*				kanji_jis0212: JIS0212�е��ձ�����<br/>
	*				greek_lowercase��ϣ���ĵ�Сд��ĸ<br/>
	*				greek_uppercase: ϣ���ĵĴ�д��ĸ<br/>
	*				latin_lowercase: ������ϵСд��ĸ<br/>
	*				latin_uppercase: ������ϵ��д��ĸ<br/>
	*				cyrillic_lowercase:�������ϵСд��ĸ<br/>
	*				cyrillic_uppercase: �������ϵ��д��ĸ<br/>
	*				arabic:	��������<br/>
	*              ֧�ֶ�ʶ��Χͬʱ���ã������Χ��+���ӣ����� lower+number+gb��������õ�
	*				�ַ�ʶ��Χ�����е�С��Χ�ϲ�Ϊ׼������ lower+alphabet ��ͬ�� alphabet��
	*				��ʹ��Ӣ��������ʶ��Χ����Ŀǰ��Ч��������������Ӣ�Ĳ�֧�ֵ�ʶ��Χ(gb��gbk��big5_5401��big5��)��
	*				�򷵻�HCI_ERR_CONFIG_UNSUPPORT��
	*			</td>
	*		</tr>
	*		<tr>
	*			<td>openSlant</td>
	*			<td>no, yes</td>
	*			<td>no</td>
	*			<td>��б��������</td>
	*			<td>no: ������б����<br/>yes: ����б����<br/></td>
	*		</tr> 
	*		<tr>
	*			<td>splitMode</td>
	*			<td>line, overlap</td>
	*			<td>line</td>
	*			<td>������дģʽ</td>
	*			<td>line: ��ʶ��<br/>overlap: ����ʶ��</td>
	*		</tr> 
	*		<tr>
	*			<td>wordMode</td>
	*			<td>mixed, capital, lowercase, initial</td>
	*			<td>mixed</td>
	*			<td>����Ӣ�ĵ��ʵĴ�Сд��ʽ</td>
	*			<td>mixed: ��ĸ��Сд���<br/>
	*			 capital: ȫ����ĸ��д<br/>
	*			 lowercase: ȫ����ĸСд<br/>
	*			 initial: ����ĸ��д
	*			</td>
	*		</tr>
	*		<tr>
	*			<td>dispCode</td>
	*			<td>nochange, tosimplified, totraditional</td>
	*			<td>nochange</td>
	*			<td>��������������ת��</td>
	*			<td>nochange: ���岻���仯<br/>tosimplified: д���ü�<br/>totraditional: д��÷�</td>
	*		</tr> 
	*		<tr>
	*			<td>fullHalf</td>
	*			<td>full, half</td>
	*			<td>half</td>
	*			<td>��������ʶ��ģʽ�����������ȫ�ǻ��ǰ��</td>
	*			<td>full: ȫ��<br/>half: ���</td>
	*		</tr>
	*		<tr>
	*			<td>subLang</td>
	*			<td>ʹ������hwr.local.letter.latinʱ����subLang=english</td>
	*			<td>��</td>
	*			<td>����������ʱѡ�����ԣ�ֻ�ܴ���1��</td>
	*			<td>���@ref sublang_list</td>
	*		</tr>
	*	</table>
	* @n@n
	* ����û�ж�����������ʹ�� session_start ʱ�Ķ��塣��� session_start ʱҲû�ж��壬��ʹ��ȱʡֵ�������ô����Դ�NULL����""��
	*
	* @note
	* <b>ʵʱʶ��(realtime����ֵΪyes)</b>
	* @n@n
	* ��������ʵʱʶ��ʱ��ÿ�ε��ñ�����ʱ������ıʼ����ݱ���Ϊ�����������ݣ�
	* �������(-1,0)(-1,-1)����������Ϊ���ݷǷ���
	* @n@n
	* ������ʵʱʶ��ʱ������ÿ��������ʶ�����ݣ����Զ�ε��ñ�������ÿ�ε���׷�������µ����ݣ�ÿ�����������
	* ��(-1,0)������Ҳ��ÿ������ıʻ��������ģ�����һ���������ʻ������һ����(-1,0)(-1,-1)������
	* ��ʾ����ʶ�������ÿ�ε��ñ��������᷵�ش�ͷ��ʼ���������������������ݻᵼ���зַ����仯��
	* ��˺�һ�ν����һ����ǰ�ν����׷���ַ������ܻ���ĵ�����ǰ�ν����ʵʱʶ����ÿ��ʶ��Ľ������Ҫ�ͷš�
	* @n@n
	* ʵʱʶ��ֻʹ��ÿ���¿���ʱ��pszConfig���ã���ʵʱʶ��������ٴ����pszConfig���ǻᱻ���ԡ�
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_recog(
		_MUST_ _IN_ int nSessionId,
		_MUST_ _IN_ short * psStrokingData,
		_MUST_ _IN_ unsigned int uiStrokingDataLen,
		_OPT_ _IN_ const char * pszConfig,
		_MUST_ _OUT_ HWR_RECOG_RESULT * psHwrRecogResult
		);

	/**  
	* @brief	�ͷ�ʶ�����ڴ�
	* @param	psHwrRecogResult	��Ҫ�ͷŵ�ʶ�����ڴ�ָ��
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����������Ϸ�</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_free_recog_result(
		_MUST_ _IN_ HWR_RECOG_RESULT * psHwrRecogResult
		);

	/**  
	* @brief	�ύȷ�Ͻ��
	* @param	nSessionId			�ỰID
	* @param	psHwrConfirmItem	Ҫ�ύ��ȷ�Ͻ��,UTF8��ʽ����'\0'���������ܳ���2048�ֽڣ�����'\0'��
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_DATA_SIZE_TOO_LARGE</td><td>�����ȷ���ı������ɴ��������</td></tr>
	*		<tr><td>@ref HCI_ERR_SESSION_INVALID</td><td>�����Session�Ƿ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_CONFIRM_NO_TASK</td><td>û�п������ύ������������δʶ��͵����˱�����</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_CONNECT_FAILED</td><td>���ӷ�����ʧ�ܣ�����������Ӧ</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_TIMEOUT</td><td>���������ʳ�ʱ</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_DATA_INVALID</td><td>���������ص����ݸ�ʽ����ȷ</td></tr>
	*		<tr><td>@ref HCI_ERR_UNSUPPORT</td><td>�ݲ�֧��</td></tr>
	*		<tr><td>@ref HCI_ERR_SERVICE_RESPONSE_FAILED</td><td>����������ʶ��ʧ��</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_confirm(
		_MUST_ _IN_ int nSessionId,
		_MUST_ _IN_ HWR_CONFIRM_ITEM * psHwrConfirmItem
		);

	/**  
	* @brief	�����Ự
	* @param	nSessionId		�ỰID
	* @return
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_SESSION_INVALID</td><td>�����Session�Ƿ�</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_session_stop(
		_MUST_ _IN_ int nSessionId
		);

	/**  
	* @brief	��ȡƴ�� ����Windowsƽ̨��Ч��
	* @param	pszWord			�ַ���ָ�룬UTF-8��ʽ���ַ�����'\0'�������������һ�����֣�ֻ���ص�һ�����ֵ�ƴ�����
	* @param	psPinyin		���ص�ƴ����Ϣ��ʹ����Ϻ���ʹ�� hci_hwr_free_pinyin_result() ���������ͷ�
	*                          Ӧ�ý��ṹ���ݿ�������ʹ��
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOCAL_LIB_MISSING</td><td>����ƴ���ֵ䶪ʧ</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_INIT_FAILED</td><td>���������ʼ��ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_FAILED</td><td>���������ȡƴ��ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOAD_FUNCTION_FROM_DLL</td><td>Ҫ�����ģ�鲻���ڣ�������Ҫ�Ĺ����ڸ�ģ�鲻����</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_pinyin(
		_MUST_ _IN_ const char * pszWord,
		_MUST_ _OUT_ PINYIN_RESULT * psPinyin
		);

	/**  
	* @brief	�ͷ�ƴ������ڴ�
	* @param	psPinyin	��Ҫ�ͷŵ�ƴ���ڴ�ָ��
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����������Ϸ�</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_free_pinyin_result(
		_MUST_ _IN_ PINYIN_RESULT * psPinyin
		);

	/**  
	* @brief	��ȡ�����
	* @details	��ȡ����ʵ�ʱ����Ȱ������봮����������룬Ȼ�����δ�ǰȥ���ַ��������룬
	*			���磬����"�л�����"��ʱ�򣬻����"���͹�"(����"�л�����"ƥ��)��"��ѧ"(����"����"ƥ�䣩��
	*			"��"(����"��"ƥ��)�ȡ����ܵ�����ʵ��ۼ�������һ�����ơ�@n
	*			�����봮Ϊȫ��Ӣ��ʱ�������Ӣ�Ĵʵ����빦�ܡ�
	* @param	pszWord			�ַ���ָ�룬UTF-8��ʽ����'\0'Ϊ��������
	* @param	psAssocWords	���ص�����ʽṹ��ʹ����Ϻ���ʹ�� hci_hwr_free_associate_words_result() ���������ͷ�
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOCAL_LIB_MISSING</td><td>���������ֵ䶪ʧ</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_FAILED</td><td>���������ȡ�����ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOAD_FUNCTION_FROM_DLL</td><td>Ҫ�����ģ�鲻���ڣ�������Ҫ�Ĺ����ڸ�ģ�鲻����</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_associate_words(
		_MUST_ _IN_ const char * pszWord,
		_MUST_ _OUT_ ASSOCIATE_WORDS_RESULT * psAssocWords
		);

	/**  
	* @brief	��ȡ�����
	* @details	��ȡ����ʵ�ʱ����Ȱ������봮����������룬Ȼ�����δ�ǰȥ���ַ��������룬
	*			���磬����"�л�����"��ʱ�򣬻����"���͹�"(����"�л�����"ƥ��)��"��ѧ"(����"����"ƥ�䣩��
	*			"��"(����"��"ƥ��)�ȡ����ܵ�����ʵ��ۼ�������һ�����ơ�@n
	*			�����봮Ϊȫ��Ӣ��ʱ�������Ӣ�Ĵʵ����빦�ܡ�
	* @param	nSessionId		�ỰID
	* @param	pszConfig		��ʼ�����ô�,ASCII�ַ�������'\0'����
	* @param	pszWord			�ַ���ָ�룬UTF-8��ʽ����'\0'Ϊ��������
	* @param	psAssocWords	���ص�����ʽṹ��ʹ����Ϻ���ʹ�� hci_hwr_free_associate_words_result() ���������ͷ�
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_FAILED</td><td>���������ȡ�����ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_SESSION_INVALID</td><td>�����Session�Ƿ�</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_INVALID</td><td>���ô��е�ֵ���Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_UNSUPPORT</td><td>�ݲ�֧��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOAD_FUNCTION_FROM_DLL</td><td>Ҫ�����ģ�鲻���ڣ�������Ҫ�Ĺ����ڸ�ģ�鲻����</td></tr>
	*	</table>
	*@par ���ô����壺
	* ���ô�����"�ֶ�=ֵ"����ʽ������һ���ַ���������ֶ�֮����','�������ֶ������ִ�Сд��
	* @n@n
	*	�������ã���������أ��������е�������֧�֣��μ� @ref hci_hwr_page ������ʹ���Ͽ���ѯ��ͨ������˾��
	*	<table>
	*		<tr>
	*			<td><b>�ֶ�</b></td>
	*			<td><b>ȡֵ��ʾ��</b></td>
	*			<td><b>ȱʡֵ</b></td>
	*			<td><b>����</b></td>
	*			<td><b>��ϸ˵��</b></td>
	*		</tr>
	*		<tr>
	*			<td>associateModel</td>
	*			<td>multi, single</td>
	*			<td>multi</td>
	*			<td>�����������Ƕ��ֻ��ǵ��֣�������ֻ֧���������룬Ӣ���������</td>
	*			<td>�������Ϊmulti���򲻻���������ʵĳ��Ƚ������ơ��������Ϊsingle�����ʾ�޶�����ʷ��ؽ��Ϊ���֡�</td>
	*		</tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_associate_words_ex(
		_MUST_ _IN_ int nSessionId,
		_OPT_ _IN_ const char * pszConfig,
		_MUST_ _IN_ const char * pszWord,
		_MUST_ _OUT_ ASSOCIATE_WORDS_RESULT * psAssocWords
		);


	/**  
	* @brief	����ʶ�̬��������ǰpszWord�ĳ���λ��
	* @details	֧�����ĵ�����ʶ�̬��������������Ǵʿ������еĴʣ����ʹ�����λ����ǰ�� ��������Ǵʿ���û��
	*			�Ĵʣ������ʿ⣬�����ֵ��ڵ�Ԥ���ռ䣬�ֵ��С���䣬Ԥ���ռ�д������������´ʽ������ǡ�@n
	*			��֧��Ӣ������ʶ�̬�����������봮Ϊȫ��Ӣ��ʱ������ʧ�ܡ�@n
	*			�������������"����"�������룬�ж�Ӧ"����"��������"��ѧ"����ʹ��������ǰ���˴�Ӧ�����
	*			"�����ѧ"�Ĵ�Ƶ����pszWordӦ����"�����ѧ"��Ӧ��UTF-8�ַ�������'\0'������
	* @param	pszWord			�ַ���ָ�룬UTF-8��ʽ����'\0'Ϊ������������2���ַ������15���ַ�(ע�⣺����15���ֽ�)��
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_DATA_SIZE_TOO_LARGE</td><td>������ı�����15���ַ�</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOCAL_LIB_MISSING</td><td>���������ֵ䶪ʧ</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_FAILED</td><td>����ʶ�̬����ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_UNSUPPORT</td><td>�ݲ�֧��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOAD_FUNCTION_FROM_DLL</td><td>Ҫ�����ģ�鲻���ڣ�������Ҫ�Ĺ����ڸ�ģ�鲻����</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_associate_words_adjust(
		_MUST_ _IN_ const char * pszWord
		);

	/**  
	* @brief	����ʶ�̬��������ǰpszWord�ĳ���λ��
	* @details	֧�����ĵ�����ʶ�̬��������������Ǵʿ������еĴʣ����ʹ�����λ����ǰ�� ��������Ǵʿ���û��
	*			�Ĵʣ������ʿ⣬�����ֵ��ڵ�Ԥ���ռ䣬�ֵ��С���䣬Ԥ���ռ�д������������´ʽ������ǡ�@n
	*			��֧��Ӣ������ʶ�̬�����������봮Ϊȫ��Ӣ��ʱ������ʧ�ܡ�@n
	*			�������������"����"�������룬�ж�Ӧ"����"��������"��ѧ"����ʹ��������ǰ���˴�Ӧ�����
	*			"�����ѧ"�Ĵ�Ƶ����pszWordӦ����"�����ѧ"��Ӧ��UTF-8�ַ�������'\0'������
	* @param	nSessionId		�ỰID
	* @param	pszConfig		��ʼ�����ô�,ASCII�ַ�������'\0'�����������ӿڣ���ʱ��������
	* @param	pszWord			�ַ���ָ�룬UTF-8��ʽ����'\0'Ϊ������������2���ַ������15���ַ�(ע�⣺����15���ֽ�)��
	* @return	
	* @n
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_DATA_SIZE_TOO_LARGE</td><td>������ı�����15���ַ�</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_FAILED</td><td>����ʶ�̬����ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_UNSUPPORT</td><td>�ݲ�֧��</td></tr>
	*		<tr><td>@ref HCI_ERR_SESSION_INVALID</td><td>�����Session�Ƿ�</td></tr>
	*		<tr><td>@ref HCI_ERR_LOAD_FUNCTION_FROM_DLL</td><td>Ҫ�����ģ�鲻���ڣ�������Ҫ�Ĺ����ڸ�ģ�鲻����</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_associate_words_adjust_ex(
		_MUST_ _IN_ int nSessionId,
		_OPT_ _IN_ const char * pszConfig,
		_MUST_ _IN_ const char * pszWord
		);

	/**  
	* @brief	�ͷ�����ʽ���ڴ�
	* @param	psAssocWords	��Ҫ�ͷŵ�������ڴ�ָ��
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����������Ϸ�</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_free_associate_words_result(
		_MUST_ _IN_ ASSOCIATE_WORDS_RESULT * psAssocWords
		);


	/**  
	* @brief	��ȡ����
	* @details	����ʼ����ȡ����λͼ��
	*			�˺��������ǰ�����δ���ĵ��λ�ù�ϵ����λͼ�����ɣ�����˴δ����������ǵ�һ�����������㣬������֮ǰ����������
	*			��ȫ��ͬ�򲻻�����λͼ�����
	*			ÿһ�ʽ�����ʱ��Ҫ����(-1,0),�������α������ɡ�
	*			�˺�����������ֻ�������������Ч��(1)��һ�ε��ô˺�����(2)��������ʼ����(-1,0)����һ�ε��ô˺�����
	*			
	* @param	pszConfig		ʶ��������ô�,ASCII�ַ�������'\0'��������ΪNULL
	* @param	nX				�ʼ���ĺ����� ȡֵ>= 0���� -1
	* @param	nY				�ʼ����������ȡֵ >= 0
	* @param	psPenScript		���صı��ͽ���ṹ��ʹ����Ϻ���ʹ�� hci_hwr_free_pen_script_result() ���������ͷ�
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����Ĳ������Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_CONFIG_INVALID</td><td>���ô��е�ֵ���Ϸ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_INIT_FAILED</td><td>��ʼ�����ο�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_OUT_OF_MEMORY</td><td>�����ڴ�ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_ENGINE_FAILED</td><td>���������ȡ����ʧ��</td></tr>
	*		<tr><td>@ref HCI_ERR_LOAD_FUNCTION_FROM_DLL</td><td>Ҫ�����ģ�鲻���ڣ�������Ҫ�Ĺ����ڸ�ģ�鲻����</td></tr>
	*	</table>
	* @par ���ô����壺
	* ���ô�����"�ֶ�=ֵ"����ʽ������һ���ַ���������ֶ�֮����','�������ֶ������ִ�Сд��
	* @n@n
	*	�������ã���������أ��������е�������֧�֣��μ� @ref hci_hwr_page ������ʹ���Ͽ���ѯ��ͨ������˾��
	*	<table>
	*		<tr>
	*			<td><b>�ֶ�</b></td>
	*			<td><b>ȡֵ��ʾ��</b></td>
	*			<td><b>ȱʡֵ</b></td>
	*			<td><b>����</b></td>
	*			<td><b>��ϸ˵��</b></td>
	*		</tr>
	*		<tr>
	*			<td>penMode</td>
	*			<td>pencil, pen, brush</td>
	*			<td>pencil</td>
	*			<td>���ñ���ģʽ</td>
	*			<td>pencil: Ǧ��<br/>pen: �ֱ�<br/>brush: ë��</td>
	*		</tr>
	*		<tr>
	*			<td>penColor</td>
	*			<td>#000000-#FFFFFF��rainbow</td>
	*			<td>rainbow</td>
	*			<td>���ñʼ���ɫ</td>
	*			<td>RGB��ɫֵ��rainbowΪ��ɫ������ֵΪ��ɫ</td>
	*		</tr>
	*		<tr>
	*			<td>penWidth</td>
	*			<td>1-15</td>
	*			<td>1</td>
	*			<td>���ñʿ�</td>
	*			<td></td>
	*		</tr> 
	*		<tr>
	*			<td>penSpeed</td>
	*			<td>1-10</td>
	*			<td>1</td>
	*			<td>���ñ��٣�����ë����Ч</td>
	*			<td>ͨ�������ʹ��Ĭ�ϱ��ټ��ɣ�����豸��Ļ�ܹ�ȡ���ĵ�����ܼ���Ӱ�쵽�˱��ο��Ч�ʿ����ʵ��������(���ٵĻ�����ͨ���������ֵ���ʵ�ֵģ�����Խ�󱻺��Եĵ�Խ��)��</td>
	*		</tr> 
	*	</table>
	*
	* @note
	* �˽ӿڲ�֧�ֶ��̲߳���,nX��ȡֵ��Χ���ڵ���-1������(nXȡֵ-1��ʱ��nY��ֵֻ����0)��nY��ȡֵ��Χ�Ǵ��ڵ���0������
	* @n@n
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_pen_script(
		_OPT_ _IN_ const char *pszConfig,
		_MUST_ _IN_ int nX,
		_MUST_ _IN_ int nY,
		_MUST_ _IN_ PEN_SCRIPT_RESULT * psPenScript
		);

	/**  
	* @brief	�ͷű��ͽ���ڴ�
	* @param	psPenScript		��Ҫ�ͷŵı��ͽ���ڴ�ָ��
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_PARAM_INVALID</td><td>����������Ϸ�</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_free_pen_script_result(
		_MUST_ _IN_ PEN_SCRIPT_RESULT * psPenScript
		);

	/**  
	* @brief	�ϴ��û�����(�ýӿ��Ѿ����������øýӿ�Ŀǰ����HCI_ERR_NONE)
	* @return	������
	* @return	
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*	</table>
	*/ 

	HCI_ERR_CODE HCIAPI hci_hwr_upload_user_history();

	/**  
	* @brief	����HWR���� ����ʼ��
	* @return
	* @n
	*	<table>
	*		<tr><td>@ref HCI_ERR_NONE</td><td>�����ɹ�</td></tr>
	*		<tr><td>@ref HCI_ERR_HWR_NOT_INIT</td><td>HCI HWR��δ��ʼ��</td></tr>
	*		<tr><td>@ref HCI_ERR_ACTIVE_SESSION_EXIST</td><td>����δstop��Sesssion���޷�����</td></tr>
	*	</table>
	*/ 
	HCI_ERR_CODE HCIAPI hci_hwr_release();

	/* @} */
	//////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
};
#endif


#endif
