# Include aliases file created by the marker script
if [ -f ~/.marker_functions ] ; then	
	source ~/.marker_functions
fi

######################################################################################################################################################
## 							                       SCRIPTS INCLUDE SECTION                 		            										##
######################################################################################################################################################

# Git bash command line completion script
 . ~/bin/git-completion.bash

# MASABI-RELATED CUSTOMIZATION SCRIPTS
. ~/bin/bash_customizations/masabi_mpg_build.sh
. ~/bin/bash_customizations/masabi_easily_connect_to_servers.sh

######################################################################################################################################################
## 							                       PATH ENVIRONMENT VARIABLE SETUP                             										##
######################################################################################################################################################

OPT_BINARIES=/Users/hassanein.khafaji/opt/gradle-2.3/bin:/Users/hassanein.khafaji/opt/groovy-2.4.3/bin

export PATH=${OPT_BINARIES}:/usr/local/Cellar/bison/3.0.2/bin:${PATH}:/Users/hassanein.khafaji/opt/vault-cli-2.4.40/bin:/usr/libexec:/usr/local/mysql/bin:/Users/khafaji/bin:/Users/hassanein.khafaji/opt/BookmarkerScript:~/bin:/Users/hassanein.khafaji/opt/gradle-1.12/bin:/Users/hassanein.khafaji/opt/jq/bin:/Users/hassanein.khafaji/opt/sonar-runner-2.4/bin:/Users/hassanein.khafaji/Projects/GoStuff/bin

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

######################################################################################################################################################
## 							                       COMMON VARIABLES export                 		            										##
######################################################################################################################################################

export GIT_BRANCH_NAME='${YELLOW}$(getGitBranchName)${WHITE}'
export MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=1024m"
export CATALINA_HOME="/usr/local/Cellar/tomcat7/7.0.61/libexec"
export JAVA_HOME=$(java_home -v 1.7)

##### PS1

export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;31m\] \W\[\033[00m\] ${GIT_BRANCH_NAME}${YELLOW}\$ \[\033[00m\]" # Black background
#export PS1='\[\033[01;34m\]\u@\h\[\033[30m\]:\[\033[01;38m\]\w\[\033[00m\]\$ ' # White background
#export LSCOLORS='Eafxcxdxbxegedabagacad

export TERM=xterm-color
export MANPAGER=more
export SVN_EDITOR="vim"

# SCREEN COLORS
export BLACK=$(tput setaf 0)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export MAGENTA=$(tput setaf 5)
export CYAN=$(tput setaf 6)
export WHITE=$(tput setaf 7)

# MASABI
export MASABI_SVN="https://svn.masabi.com/svn/"


######################################################################################################################################################
## 							                                    COMMON ALIASES    	                 		            							##
######################################################################################################################################################
set -o vi

alias r="fc -e -"
alias o="open"
alias chrome="open -a \"Google Chrome\""
alias ll="ls -ltrG"
alias ls="ls -G"
alias tw="open -a TextWrangler"
alias preview="open -a preview"
alias cls="clear"
alias things="open -a things"
alias chrome="open -a Google Chrome"
alias xcode="open -a xcode"
alias sl="open -a Sublime\ Text.app"
alias bnd="java -jar /Users/hassanein.khafaji/opt/biz.aQute.bnd-latest.jar"
alias gitlog='git log --pretty=format:"%H: %Cred %an - %Cgreen %ad - %Cblue %s"'
alias st="git st"
alias br="git br"

# These are not needed now, but might need them in the future. It might be a good idea to write a very short blog post explaining the functionality for future reference
alias aut="curl -u admin:admin -d 'apply=true&action=ajaxConfigManager&wcmfilter.mode=edit&propertylist=wcmfilter.mode&submit=Save' http://localhost:4502/system/console/configMgr/com.day.cq.wcm.core.WCMRequestFilter"
alias pub="curl -u admin:admin -d 'apply=true&action=ajaxConfigManager&wcmfilter.mode=disabled&propertylist=wcmfilter.mode&submit=Save' http://localhost:4502/system/console/configMgr/com.day.cq.wcm.core.WCMRequestFilter"

alias vi="vim"

alias c="pbcopy"
alias p="pbpaste"

alias killAllApps="ps -ef | grep /Applications | grep -v grep | grep -vi iterm | awk '{print $2}' | xargs kill -9"
alias jd="open -a JD-GUI"

alias prof="sl ~/.bash_profile"
alias tempscript="touch ~/tmp/tmp.sh && sl ~/tmp/tmp.sh"

eval $(boot2docker shellinit 2> /dev/null)

######################################################################################################################################################
## 							                                    COMMON FUNCTIONS    	                 		            						##
######################################################################################################################################################

function mark()
{
	markme $*
	. ~/.bash_profile
}

function umark()
{
	umarkme $*
	unset $*
}

function gitit
{
	# Add the untracked file to git
	git add -A .
	# Commit the changes
	git commit -m "$1"
	# merge with the master branch on github
	git push -u origin master
}

function scgrep()
{
	for sourceCodeFile in $(find . -type f | grep -v svn | grep Procedure)
	do
		grep -il $1 ${sourceCodeFile}
	done | grep -v $1
}

function nkill()
{
	for pid in $(ps -ef | grep -i $1 | grep -v grep | awk '{print $2}')
	do
		echo "Terminating ${pid}..."
		kill -15 $pid
	done
}

function svn_commit()
{
	svn st
	svnAddAll
	svn commit -m "$1"
}

function dumpJcrAt()
{
	vlt --credentials admin:admin co http://localhost:4502/crx/-/jcr:root${1}
}

function generateSurefireReport()
{	
	for file in *.xml
		do echo "${file}: $(cat ${file} | grep '<testsuite fail' | awk -F "errors" '{print $1}' | cut -d "=" -f3)" 
	done | sort -t '"' -k 2.1nr | awk '{print $2}' | sed 's/"//g' | awk 'START{x=0} {x+=$1} END{print "\nTests execution time: " x/60" min\n"}'
}

function svnAddAll()
{
	svn st | grep ^? | awk '{print $2}' | xargs svn add
}

function commit()
{
	git add .
	git commit -am "$1"
}

function svnDeleteAll()
{
  svn st | grep ^!  | awk '{print $2}' | xargs svn delete
}

# Here is a function that retrieves all the JARs that are available on Adobe CQ classpath
# for later de-compilation and further examination to develop an understanding of how Adobe CQ works internally.
function downloadAdobeCQJars()
{
	[ -z "$CRX_URL" ] && CRX_URL="http://vmd-mini-auth.emea.akqa.local:4502"
	[ -z "$CRX_CREDENTIALS" ] && CRX_CREDENTIALS="admin:admin"

	# Get the CRX classpath and save it into a file for later processing
	curl -H x-crxde-version:1.0 -H x-crxde-os:mac -H x-crxde-profile:default -u $CRX_CREDENTIALS $CRX_URL/bin/crxde.classpath.xml > .classpath 2> /dev/null	
	FILELIST=$(cat .classpath | sed -n '/lib/s/.*WebContent\(.*\)\".*/\1/p')
	
	# download all the jars
	for FILE in $FILELIST
	do
		echo "downloading $FILE ..."
		curl -u $CRX_CREDENTIALS ${CRX_URL}${FILE} -O 2> /dev/null
	done

	# remove the temp files
	rm -fr .classpath
}

function reOpenAllTunnels()
{
	nkill ssh

	. ~/bin/openTunnels.sh

	openAllTunnels $1
}

function getGitBranchName()
{
	OPEN_PARENTHESES="("
	CLOSE_PARENTHESES=")"
		
	if weHaveATag
		then			
			CURRENT_BRANCH="$(git branch 2> /dev/null | grep '^*' | awk '{print $4}' | sed 's/)//g')"
		else								
			CURRENT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')						
	fi
	[ ! -z ${CURRENT_BRANCH} ] && echo "${OPEN_PARENTHESES}${CURRENT_BRANCH}${CLOSE_PARENTHESES} "
}

function weHaveATag()
{
	git branch 2> /dev/null | grep "detached from" > /dev/null	
	return $?
}	

function toggleGitBranchInPrompt
{
	echo ${PS1} | grep getGitBranchName &> /dev/null
	if ( test $? -eq "0")
	then
		export PS1=$(echo ${PS1} | sed "s/${GIT_BRANCH_NAME}//g")
	else
		export PS1=$(echo ${PS1} | sed "s_\(\\\$\)_${GIT_BRANCH_NAME}\1_")
	fi
}

function t()
{
	SEARCH_WORD=$(echo $1 | tr '[:upper:]' '[:lower:]')
	open -a /Applications/Google\ Chrome.app/ http://dictionary.cambridge.org/dictionary/british/${SEARCH_WORD}
}

function reload()
{
	. ~/.bash_profile
	cd - &> /dev/null
    figlet -f roman "Profile reloaded"
}

function deleteAllDockerImages()
{
	for imageID in $(docker images | awk '{print $3}' | grep -v IMAGE)
	do 
		docker rmi --force ${imageID}
	done
}

function readlink()
{
	echo $@
}

function sendAlertToMpgHipchat()
{
  curl -X POST --header "content-type: application/json" "http://api.hipchat.com/v2/room/MPG-LOGGLY-ALERTS/notification?auth_token=UrxxngPc9UMO0Jq5ZOe6SuPnsNKgRqDLQsvYiXW7" --data '{"message":"$1"}'
}
