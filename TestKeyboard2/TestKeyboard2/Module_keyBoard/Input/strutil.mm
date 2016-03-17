////////////////////////////////////////////////////////////////////////////////
//
// Utilities for std::string
// defined in namespace strutil
// by James Fancy
//
////////////////////////////////////////////////////////////////////////////////
#include "strutil.h"

// add by lyx
#ifdef __ANDROID__
#include <ctype.h>
#endif

#include <algorithm>

namespace strutil {

	using namespace std;

	string trimLeft(const string& str) {
		string t = str;
		t.erase(0, t.find_first_not_of(" \t\n\r"));
		return t;
	}

	string trimRight(const string& str) {
		string t = str;
		t.erase(t.find_last_not_of(" \t\n\r") + 1);
		return t;
	}

	string trim(const string& str) {
		string t = str;
		t.erase(0, t.find_first_not_of(" \t\n\r"));
		t.erase(t.find_last_not_of(" \t\n\r") + 1);
		return t;
	}

	string toLower(const string& str) {
		string t = str;
#if defined (__LINUX__) || defined (__IOS__)
		transform(t.begin(), t.end(), t.begin(), ::tolower);
#else
		int (*tl)(int) = tolower; 
		transform(t.begin(), t.end(), t.begin(), tl);
#endif
		return t;
	}

	string toUpper(const string& str) {
		string t = str;
		transform(t.begin(), t.end(), t.begin(), ::toupper);
		return t;
	}

	string replace(const string & str, const string &sub, const string & change)
	{
		string t = str;
		t.replace(t.find(sub), sub.size(), change);
		return t;
	}

	bool startsWith(const string& str, const string& substr) {
		return str.find(substr) == 0;
	}

	bool endsWith(const string& str, const string& substr) {
		return str.rfind(substr) == (str.length() - substr.length());
	}

	bool equalsIgnoreCase(const string& str1, const string& str2) {
		return toLower(str1) == toLower(str2);
	}

	template<bool>
		bool parseString(const std::string& str) {
			bool value;
			std::istringstream iss(str);
			iss >> boolalpha >> value;
			return value;
		}

	string toString(const bool& value) {
		ostringstream oss;
		oss << boolalpha << value;
		return oss.str();
	}

	vector<string> split(const string& str, const string& delimiters) {
		vector<string> ss;
		
		split(ss, str, delimiters);

		return ss;
	}

	void split(vector<string> & ss, const string& str, const string& delimiters) {
		Tokenizer tokenizer(str, delimiters);
		while (tokenizer.nextToken()) {
			ss.push_back(tokenizer.getToken());
		}
	}
	const char* DEFAULT_DELIMITERS = "  ";

	Tokenizer::Tokenizer(const std::string& str)
		: m_String(str), m_Offset(0), m_Delimiters(DEFAULT_DELIMITERS) {}

	Tokenizer::Tokenizer(const std::string& str, const std::string& delimiters)
		: m_String(str), m_Offset(0), m_Delimiters(delimiters) {}

	bool Tokenizer::nextToken() {
		return nextToken(m_Delimiters);
	}

	bool Tokenizer::nextToken(const std::string& delimiters) {
		// find the start charater of the next token.
		size_t i = m_String.find_first_not_of(delimiters, m_Offset);
		if (i == string::npos) {
			m_Offset = m_String.length();
			return false;
		}

		// find the end of the token.
		size_t j = m_String.find_first_of(delimiters, i);
		if (j == string::npos) {
			m_Token = m_String.substr(i);
			m_Offset = m_String.length();
			return true;
		}

		// to intercept the token and save current position
		m_Token = m_String.substr(i, j - i);
		m_Offset = j;
		return true;
	}

	const string Tokenizer::getToken() const {
		return m_Token;
	}

	void Tokenizer::reset() {
		m_Offset = 0;
	}

}
