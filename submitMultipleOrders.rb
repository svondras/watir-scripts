require 'watir-webdriver'

class Browser

  attr_accessor  :user, :pw
  
  @enviro = ""
  
  def launchbrowser 
    print "Enter environment: "
    @enviro = gets.chomp
    @enviro.downcase!
    enviro_array = ["at", "duff", "grue", "hotfix", "nova", "qa", "prod", "scooby", "worksforus"]
    
    if @enviro.length == 0
      @enviro = 'scooby'
    end
    
    if enviro_array.include?(@enviro)
      
    else 
        if @enviro == "exit"
          abort("Good bye!")
        else  
            puts "Invalid entry, try again"
            abort("Good bye!")
        end
    end
    @enviro.downcase!
    puts @enviro
    
    browser = Watir::Browser.new :firefox
    browser.driver.manage.window.maximize
    
    if @enviro == "prod"
      browser.goto "https://www.asurint.com/Login.aspx"
    else
      browser.goto "https://#{@enviro}.asurint.com/Login.aspx"
    end

    browser.text_field(:id => 'username').set user

    browser.text_field(:id => 'password').set pw
    
    browser.button(:id => 'ctl00_ContentPlaceHolder1_btnLogin').when_present.click
    sleep 2
   
    return browser
    end
    
    def getenviro
      return @enviro
    end
    
end

class Orders

  attr_accessor :browser, :enviro, :ssn, :type, :user, :pw
  
  def droporder(ssn, enviro, type)
  
  if type == 'ala'
    case enviro
      when "hotfix" 
        browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
      when "scooby" 
        browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
      end
  end
  
  if type == 'cc'
    browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
  end
  
  if type == 'sjv'
    case enviro
  
    when "at"
      browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
    when 'scooby'
      browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
    
    when "qa"
      browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
    when "hotfix"
      browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
    end
    
  end
  
  if type == 'criminal' || type == 'pat'
    if enviro == 'prod'
      browser.goto "https://www.asurint.com/secure/SearchWizard.aspx?packageId="
    else
      browser.goto "https://#{enviro}.asurint.com/secure/SearchWizard.aspx?packageId="
    end
    
  end
  
    sleep 2
    browser.text_field(:id => 'ctl00_contentPage_step245967147_txtSSN' ).when_present.set ssn
    
    if type == 'pat'
    
      browser.text_field(:id => 'ctl00_contentPage_step245967147_txtDOB').when_present.set '04281994'
      browser.text_field(:id => 'ctl00_contentPage_step245967147_txtFirstName').when_present.set 'First'
      browser.text_field(:id => 'ctl00_contentPage_step245967147_txtMiddleName').when_present.set 'Middle'
      browser.text_field(:id => 'ctl00_contentPage_step245967147_txtLastName').when_present.set 'Last'
    end

    browser.select_list(:id => 'ctl00_contentPage_step245967147_listIntendedUse').select 'Application Verification Only'
    sleep 2
    if type == 'criminal' || type == 'pat'
      browser.checkbox(:id => 'ctl00_contentPage_step245967147_panelSearchType_checkCriminal').when_present.set
    end
    
    if type == 'emp'
      browser.text_field(:id => 'ctl00_contentPage_step245967147_txtPhoneNumber').set '(999) 999-9999'
      browser.checkbox(:id => 'ctl00_contentPage_step245967147_panelSearchType_checkEmploymentVerificationPremium_Nationwide').when_present.set
    end
    
    if type == 'edu'
      browser.checkbox(:id => 'ctl00_contentPage_step245967147_panelSearchType_checkEducationVerificationPremium_Nationwide').when_present.set
    end
    
    sleep 2
    browser.button(:id => 'ctl00_contentPage_btnContinue').click
    browser.select_list(:id => 'ctl00_contentPage_step413302276_listGender').when_present.select 'Male'
    
    browser.checkbox(:id => 'ctl00_contentPage_step413302276_listNames_ctrl0_checkPrimaryName').set
    sleep 2
    if type != 'pat'
      
      bc = browser.checkbox(:id => 'ctl00_contentPage_step413302276_listNames_ctrl0_listDOBs_ctrl0_checkPrimaryDOB')
      if bc.exists?
        browser.checkbox(:id => 'ctl00_contentPage_step413302276_listNames_ctrl0_listDOBs_ctrl0_checkPrimaryDOB').when_present.set
      else
          
          browser.text_field(:id => 'ctl00_contentPage_step413302276_txtDOBPri').when_present.set '08121985'
      end
      
    end
    sleep 2
    browser.button( :id => 'ctl00_contentPage_btnContinue').click
    sleep 2
    if type == 'criminal'
      browser.checkbox( :id => 'ctl00_contentPage_step2144197950_checkNCIB').when_present.set
    end
    if type == 'pat'
      browser.checkbox( :id => 'ctl00_contentPage_step2144197950_checkNCIB').when_present.set
      browser.checkbox( :id => 'ctl00_contentPage_step2144197950_checkOFAC').when_present.set
    end
    
    if type == 'ala'
      browser.text_field(:id => 'ctl00_contentPage_step245967147_txtPhoneNumber').set '(999) 999-9999'
    end
    
    sleep 2
    browser.button( :id => 'ctl00_contentPage_btnContinue').when_present.click
    sleep 2
    browser.button( :id => 'ctl00_contentPage_btnContinue').when_present.click
    sleep 2
   # browser.goto "https://#{enviro}.asurint.com/Secure/Reports.aspx" # go to reports page
    
  end
  
end

NewBrowser = Browser.new

user = "secret"; pw = "secret"

NewBrowser.user = user
NewBrowser.pw = pw
mybrowser = NewBrowser.launchbrowser

Order = Orders.new
Order.browser = mybrowser

Order.droporder('111223333', NewBrowser.getenviro, 'criminal')
