
#ifndef __JTCOMMON_STRUTIL_H__
#define __JTCOMMON_STRUTIL_H__

#include <string>
#include <vector>
#include <sstream>
#include <iomanip>

// add by lyx
#if defined(__ANDROID__) || defined(__LINUX__) || defined (__IOS__)
using namespace std;
#endif

// declaration
namespace strutil {

	std::string trimLeft(const std::string& str);
	std::string trimRight(const std::string& str);
	std::string trim(const std::string& str);

	std::string toLower(const std::string& str);
	std::string toUpper(const std::string& str);

	bool startsWith(const std::string& str, const std::string& substr);
	bool endsWith(const std::string& str, const std::string& substr);
	bool equalsIgnoreCase(const std::string& str1, const std::string& str2);

	std::string replace(const std::string & str, const std::string &sub, const std::string & change);

	template<class T> T parseString(const std::string& str);
	template<class T> T parseHexString(const std::string& str);
	template<bool> bool parseString(const std::string& str);

	template<class T> std::string toString(const T& value);
	template<class T> std::string toHexString(const T& value, int width = 0);
	std::string toString(const bool& value);

	std::vector<std::string> split(const std::string& str, const std::string& delimiters);
	void split(std::vector<std::string> & ss, const std::string& str, const std::string& delimiters);

// Tokenizer class
	class Tokenizer
	{
	public:
		Tokenizer(const std::string& str);
		Tokenizer(const std::string& str, const std::string& delimiters);

		bool nextToken();
		bool nextToken(const std::string& delimiters);
		const std::string getToken() const;

		/**
		* to reset the tokenizer. After reset it, the tokenizer can get
		* the tokens from the first token.
		*/
		void reset();

	protected:
		size_t m_Offset;
		const std::string m_String;
		std::string m_Token;
		std::string m_Delimiters;
	};

// implementation of template functions
	template<class T> T parseString(const std::string& str) {
		T value;
		std::istringstream iss(str);
		iss >> value;
		return value;
	}

	template<class T> T parseHexString(const std::string& str) {
		T value;
		std::istringstream iss(str);
		iss >> std::hex >> value;
		return value;
	}

	template<class T> std::string toString(const T& value) {
		std::ostringstream oss;
		oss << value;
		return oss.str();
	}

	template<class T> std::string toHexString(const T& value, int width) {
		std::ostringstream oss;
		oss << std::hex;
		if (width > 0) {
			oss << std::setw(width) << std::setfill('0');
		}
		oss << value;
		return oss.str();
	}

}


#endif