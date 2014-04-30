# Include aliases file created by the marker script
if [ -f ~/.marker_functions ] ; then	
	source ~/.marker_functions
fi
# Variables export section
###########################################################################
export CATALINA_HOME="/Users/khafaji/opt/apache-tomcat-6.0.36"
export PATH=/usr/local/bin:${PATH}:/Users/hassanein.khafaji/opt/vault-cli-3.1.6/bin:/usr/libexec:/usr/local/mysql/bin:/Users/khafaji/bin:/Users/hassanein.khafaji/opt/BookmarkerScript

export MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=512m"
export JAVA_HOME=$(java_home -v 1.6)
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\$ ' # Black background
#export PS1='\[\033[01;34m\]\u@\h\[\033[30m\]:\[\033[01;38m\]\w\[\033[00m\]\$ ' # White background
#export LSCOLORS='Eafxcxdxbxegedabagacad'
export TERM=xterm-color
export MANPAGER=more


###########################################################################
# Aliases Definitions
###########################################################################
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

# These are not needed now, but might need them in the future. It might be a good idea to write a very short blog post explaining the functionality for future reference
# alias aut="curl -u admin:admin -d 'apply=true&action=ajaxConfigManager&wcmfilter.mode=edit&propertylist=wcmfilter.mode&submit=Save' http://localhost:4502/system/console/configMgr/com.day.cq.wcm.core.WCMRequestFilter"
# alias pub="curl -u admin:admin -d 'apply=true&action=ajaxConfigManager&wcmfilter.mode=disabled&propertylist=wcmfilter.mode&submit=Save' http://localhost:4502/system/console/configMgr/com.day.cq.wcm.core.WCMRequestFilter"
alias vi="vim"

alias c="pbcopy"
alias p="pbpaste"

alias killAllApps="ps -ef | grep /Applications | grep -v grep | grep -vi iterm | awk '{print $2}' | xargs kill -9"
alias jd="open -a JD-GUI"

alias prof="sl ~/.bash_profile"

###########################################################################
# Functions Definitions
###########################################################################
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
	# Add the unversioned file to git
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
	vlt --credentials admin:stageAdmin55 co http://cms.virginatlantic.stage.lbi.co.uk/crx/-/jcr:root${1}
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

function svnDeleteAll()
{
  svn st | grep ^!  | awk '{print $2}' | xargs svn delete
}

# This is an example for how to automatically connect to a certain environment without interactively supplying a password
# function stagepublish()
# {
# 	expect -c 'spawn ssh weblogic@www.virginatlantic.stage.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
# }
