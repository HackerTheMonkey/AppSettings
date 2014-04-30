# Include aliases file created by the marker script
if [ -f ~/.marker_functions ] ; then	
	source ~/.marker_functions
fi
# Variables export section
###########################################################################
export CATALINA_HOME="/Users/khafaji/opt/apache-tomcat-6.0.36"
export PATH=/Users/khafaji/MyProjects/LBI_PROJECTS/trunk/vaa-website/node_modules/grunt-cli/bin:/usr/local/bin:${PATH}:/Users/khafaji/opt/vault-cli-2.3.6/bin:/usr/libexec:/usr/local/mysql/bin:/Users/khafaji/opt/phantomjs-1.9.1-macosx/bin:/Users/khafaji/bin:/Users/khafaji/bin/BookmarkerScript:/usr/local/go/bin

export GOPATH="/Users/khafaji/tmp/GoCode"

export MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=512m"
export VAA_SVN="http://svn.lbi.co.uk/SVN/VAA/Troy/trunk"
export SCALA_HOME="/usr/local/Cellar/scala/2.9.2"
export JAVA_HOME=$(java_home -v 1.6)
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\$ ' # Black background
#export PS1='\[\033[01;34m\]\u@\h\[\033[30m\]:\[\033[01;38m\]\w\[\033[00m\]\$ ' # White background
#export LSCOLORS='Eafxcxdxbxegedabagacad'
export TERM=xterm-color
export MANPAGER=more
export REGP="VAA Regression Pack:"

# VAA Environments

export STAGE="http://www.virginatlantic.lbi.co.uk"

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
alias tomcatlog="tail -f /Users/khafaji/opt/apache-tomcat-6.0.35/logs/catalina.out"
alias crxlog="tail -f /Users/khafaji/opt/cq/crx-quickstart/logs/error.log"
alias stdolog="tail -f /Users/khafaji/opt/cq/crx-quickstart/logs/stdout.log"
alias logs="cd /Users/khafaji/opt/cq/crx-quickstart/logs"
alias cq="cd /Users/khafaji/opt/cq/crx-quickstart"
alias sl="open -a Sublime\ Text.app"
alias gogo="telnet localhost 6666"
alias aut="curl -u admin:admin -d 'apply=true&action=ajaxConfigManager&wcmfilter.mode=edit&propertylist=wcmfilter.mode&submit=Save' http://localhost:4502/system/console/configMgr/com.day.cq.wcm.core.WCMRequestFilter"
alias pub="curl -u admin:admin -d 'apply=true&action=ajaxConfigManager&wcmfilter.mode=disabled&propertylist=wcmfilter.mode&submit=Save' http://localhost:4502/system/console/configMgr/com.day.cq.wcm.core.WCMRequestFilter"
alias vi="vim"

alias jsp="cd /Users/khafaji/MyProjects/LBI_PROJECTS/hasanein/vaa-jsp-tests"

alias staticSite="ssh weblogic@static.virginatlantic.dev.lbi.co.uk"

alias c="pbcopy"
alias p="pbpaste"

alias killAllApps="ps -ef | grep /Applications | grep -v grep | grep -vi iterm | awk '{print $2}' | xargs kill -9"
alias jd="open -a JD-GUI"

alias prof="sl ~/.bash_profile"

alias regrun='mvn clean test -Dspecs.base.dir="/Users/khafaji/tmp/specs_report" -Dselenium.waitvalue=15 -Denvironment=mocked -Dhost.env=www.virginatlantic.stage.lbi.co.uk -Dtest=com.lbi.vaa.regression.flightsearch.mobile.* -Dvaa.web.driver="mobile"'

alias python='/usr/local/bin/python3.3'
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

function wbd()
{
	cd /Users/khafaji/MyProjects/LBI_PROJECTS/trunk/vaa-website-build-deploy
	mvn clean install -DskipTests -P local
}

function dumpJcrAt()
{
	vlt --credentials admin:stageAdmin55 co http://cms.virginatlantic.stage.lbi.co.uk/crx/-/jcr:root${1}
}

function dumpOlciMmb()
{
	mkdir JCR
	cd JCR
	dumpJcrAt /apps/vaa/components/content/olcimmb
}

function startfelix()
{
	cd /Users/khafaji/opt/felix-framework-4.2.1
	java -jar ./bin/felix.jar
}

function startcq()
{
	cd /Users/khafaji/opt/cq/crx-quickstart/bin
	./start > /dev/null 2>&1
}

function startMock()
{
	vaa
	cd vaa-mock-ws
	./start-mocking.sh
}

function stopMock()
{
	ps -ef | grep soapui | grep -v grep | awk '{print $2}' | xargs kill -9
}

# Restart tomcat
function restart()
{
	ps -ef | grep tomcat | grep -v grep | awk '{print $2}' | xargs kill -9 && cd $CATALINA_HOME && ./bin/startup.sh
}

function generateSurefireReport()
{	
	for file in *.xml
		do echo "${file}: $(cat ${file} | grep '<testsuite fail' | awk -F "errors" '{print $1}' | cut -d "=" -f3)" 
	done | sort -t '"' -k 2.1nr | awk '{print $2}' | sed 's/"//g' | awk 'START{x=0} {x+=$1} END{print "\nTests execution time: " x/60" min\n"}'
}

function createSimpleBooking()
{
	cd /Users/khafaji/MyProjects/LBI_PROJECTS/trunk/vaa-flightsearch-ui
	mvn test -Dtest=SSPCreateBookingServiceIntegrationTest#completeBooking_Return_from_LHR_to_PEK
}

function runHealthCheck()
{
	 buildNumber=$(curl --user khafajih:'r&demp14' -X POST http://bamboo.lbi.co.uk/rest/api/latest/queue/VAA-STAGEH.json?os_authType=basic | awk -F ":" '{print $3}' | awk -F "," '{print $1}')
	 open -a safari http://bamboo.lbi.co.uk/browse/VAA-STAGEH-${buildNumber}	 
}

function svnAddAll()
{
	svn st | grep ^? | awk '{print $2}' | xargs svn add
}

function svnDeleteAll()
{
  svn st | grep ^!  | awk '{print $2}' | xargs svn delete
}

# This is a temporary functiont o help in facilitating the creation of mock files. This should be removed once all the mocks have been created.
function createMockResponse()
{
	cd /Users/khafaji/MyProjects/LBI_PROJECTS/vaa-regression-mock-webservices/src/main/resources/boombox_responses
	mkdir $1
	cd $1
	touch ${2}.xml
	sl ${2}.xml
}

function stagepublish()
{
	expect -c 'spawn ssh weblogic@www.virginatlantic.stage.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
}


function stageauthor()
{
	expect -c 'spawn ssh weblogic@cms.virginatlantic.stage.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
}

function devstatic()
{
	expect -c 'spawn ssh weblogic@www.virginatlantic.dev.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'	
}

function devpublish()
{
	expect -c 'spawn ssh weblogic@www.virginatlantic.dev.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
}

function regmachine()
{
	expect -c 'spawn ssh weblogic@www.virginatlantic.reg.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
}


function devauthor()
{
	expect -c 'spawn ssh weblogic@cms.virginatlantic.dev.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
}

function uatpublish()
{
	expect -c 'spawn ssh weblogic@www.virginatlantic.uat.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
}


function uatauthor()
{
	expect -c 'spawn ssh weblogic@cms.virginatlantic.uat.lbi.co.uk;expect "password:";send "w3bl0g1c\r";interact'
}

function howManyMocks()
{
  find . -name '*.java' | xargs grep -il 'buildChildElement(MockFlightSearchDepartureDatePicker.class, this)' | wc -l
}

##
# Your previous /Users/khafaji/.bash_profile file was backed up as /Users/khafaji/.bash_profile.macports-saved_2012-04-20_at_16:34:30
##

# MacPorts Installer addition on 2012-04-20_at_16:34:30: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
