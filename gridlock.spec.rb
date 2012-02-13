#!/usr/bin/ruby

require 'gridlock.rb'

describe GridLock::Manager do
  before :each do
    def foobar_rbc
      foobar_rbc = <<EOS
       -01- | -02- | -03- | -04- | -05- | -06- | -07- | -08- | -09- | -10- | -11- | -12- | -13-
      -----------------------------------------------------------------------------------------
-AA- | mida | gafy | cihi | suvi | kica | baxa | jaqu | lyho | lidy | doxu | wiwy | gago | vefy
-BB- | fyba | tygi | vusy | qovu | vahe | qebu | viry | pyxa | vaco | quby | jazy | nune | luro
-CC- | puva | kuga | rone | bexa | xano | refe | kify | podi | zala | tyne | topo | wixy | tuxa
-DD- | vyho | bavo | vede | haja | ryki | rymi | faza | kowu | qeji | vybu | taqa | nyla | tyqa
-EE- | neba | pata | gany | paqa | kifa | rira | roqi | hafu | huve | xyju | cybo | buko | joxu
-FF- | kalu | cazy | fiku | fyhi | movu | cosi | somo | cefe | liho | tiko | joji | boko | mago
-GG- | kofa | fogu | huki | loje | hubu | zoda | piqa | sela | kezi | tegy | rivy | beqo | pigy
-HH- | caze | dufe | dodi | badi | hegu | huwa | sagy | kovi | guwu | jepa | jyvi | bipa | cive
-II- | hijy | tiqu | tafi | gequ | lule | dato | kuvi | lyza | seby | xuqe | qyvy | myja | loqa
-JJ- | tuje | quxy | jeva | jico | voda | mazo | kopa | vuno | fiko | suge | xowo | mige | liba
-KK- | refi | lili | fopy | dume | gete | xoqy | zeta | sopu | tovy | raby | lili | para | tyle
-LL- | jada | hybi | sewo | rylu | geqa | xoke | wasa | pile | pylo | hesu | veno | gape | vimo
-MM- | becu | qemo | bofe | ciha | bazo | goxu | mude | xynu | gyve | xeqo | ruwa | hara | cyle
-NN- | wuxa | kere | raxo | zoky | zito | suda | vogu | wyjo | qyle | dazy | bori | xuxu | debu
-OO- | pyni | zuhu | voja | felo | myny | tale | gomi | moho | hoce | dape | gudy | nebu | jezo
-PP- | gaho | sofi | nusu | kade | nete | fodi | fone | cola | lixe | qahe | gany | bexy | pace
-QQ- | sime | xyku | hyfi | sika | legy | tido | bika | sysu | sove | xiwe | buce | qihe | duby
-RR- | riri | voju | zita | wexy | jyku | jahe | rexy | raty | nady | zihy | hobu | sihu | ruto
-SS- | vewi | jude | fuwo | vogy | supa | vidu | vepy | lize | pyje | lyno | podo | jiro | wopi
-TT- | lico | syma | tydo | wuwi | saze | bebi | tifo | tohy | supy | riti | vehe | xoma | nywo
-UU- | muca | kowy | juhe | pohe | liki | dawi | tuga | vymy | jydo | xubo | mofo | xaru | niti
-VV- | jovo | qose | ciho | myku | sylo | zeza | luni | zuxi | cefi | tyba | kequ | moti | qyba
-WW- | fevy | qosy | mato | coxa | zyxe | vebo | mudy | rybe | zagi | fufe | roto | wavo | pyke
-XX- | bubo | jafe | lazi | rajo | rovi | nosa | qike | jasa | wowi | fogi | xebu | tefo | labe
-YY- | gohi | degy | jere | rica | jova | niro | koki | wova | xeqy | leli | semi | gony | faro
-ZZ- | pucu | tuso | pipo | zasa | vici | kedu | vice | cono | gany | taky | fowe | gaxo | kiwi
EOS
    end

    def foobar_ymail
      foobar_ymail = <<EOS
       -01- | -02- | -03- | -04- | -05- | -06- | -07- | -08- | -09- | -10- | -11- | -12- | -13-
      -----------------------------------------------------------------------------------------
-AA- | tyxi | pyzi | fene | tace | nize | riky | bopa | redi | qele | huco | nizu | tiqa | ciqe
-BB- | tiho | jusu | suqa | toze | cuvi | kyqu | vyqe | zilo | mere | fafu | reqy | qufo | zyjo
-CC- | xazu | nufa | fika | muce | buke | hamu | mome | muru | tane | nefa | syge | tilu | gahi
-DD- | resu | xydi | facu | qavo | welu | tive | mony | woku | daby | vovy | toru | liza | vuce
-EE- | fape | fetu | wori | gyre | rera | nebu | waga | buqo | buki | tuvi | nojo | cehu | sidy
-FF- | mupe | vyvy | move | woje | mame | gene | bacy | tagu | divu | zyda | bube | duca | rivi
-GG- | vure | dugo | roca | huha | lumi | haxy | qyfo | lalu | zosy | vave | luki | xixe | laxe
-HH- | cepe | tiwu | paca | diwe | xyfe | mili | beko | ziwo | pyvo | codo | cyho | vosu | gaxy
-II- | pisa | wyzu | huna | wule | pomi | qudi | bify | joho | xife | xixy | roco | hobi | qeso
-JJ- | poho | qumo | hypu | koqa | limy | nesu | moti | wyhy | peba | tapi | puqo | jato | wyze
-KK- | lite | difa | kufe | deci | fenu | tehu | civu | rojy | zixi | weby | puce | nyfe | nono
-LL- | cugi | faxa | moxa | xute | gejo | jato | fuka | xave | qija | syfe | fati | duki | qumu
-MM- | fiku | pyto | puny | gobi | qybi | mimi | rule | tina | ropi | pofe | qyzo | pedi | zana
-NN- | ruci | nubu | lasi | wiqi | pocy | kede | fisa | jepo | tuki | xoki | ryle | dazi | woki
-OO- | cudi | fypo | mere | zogy | vija | tope | tafo | lucy | nate | copa | nize | jibu | hejo
-PP- | kedo | dizu | tury | wavo | hajy | ryby | zada | lapu | hevo | wufu | luci | dahy | suzu
-QQ- | xome | befe | jevy | qaby | lepi | bodo | lyxy | coto | jofo | poja | qimi | fymy | zomo
-RR- | puri | xoco | wyhu | covi | fewa | pava | vyvy | qyca | xamu | huba | kuxo | waqy | resu
-SS- | zyze | viku | fahy | quli | bejy | hyge | xone | tewy | hera | qifo | myru | ruru | buve
-TT- | cixy | lebu | nuqu | zuzi | kufo | qubi | dija | hyha | wibo | myki | fyqi | kibi | molo
-UU- | cyve | mihu | dyso | cige | bivi | loxu | kawi | hagu | bote | nova | zepa | wagi | tiwe
-VV- | tuqi | sesi | bysu | nyme | gyle | vana | waty | puqo | zuwi | xoqo | dylo | gona | jume
-WW- | hity | vamy | bumi | zyso | lopu | duqo | poma | quku | koli | tyta | sijy | nyry | joxa
-XX- | bamo | giti | pypu | belu | piku | wury | qecy | weji | puqe | rete | xawe | fise | tuti
-YY- | ruwi | lidy | mato | cexy | lubi | rela | desa | kujo | mewe | zoge | zoxe | sygy | foni
-ZZ- | cuho | gixu | zizu | hyxa | xyku | puvy | xoba | gafu | juso | begy | bapu | webu | husi
EOS
    end
  end

  it 'should set the service key and prompt for master password' do
    password = 'my_password'
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).exactly(2).times.and_return(password)
    obj.master_pass.should == password
  end

  it 'should raise on receiving an empty password' do
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).and_return('')
    lambda{obj.master_pass}.should raise_error(GridLock::PassphraseLengthError)
  end

  it 'should raise on receiving a verification password that does not match' do
    service = 'ymail.com'
    obj = GridLock::Manager.new(service)
    obj.should_receive(:ask).and_return('abc')
    obj.should_receive(:ask).and_return('def')
    lambda{obj.master_pass}.should raise_error(GridLock::PassphraseMatchError)
  end

  it 'should produce the same grid on the same input, and a different grid on different input' do
    password = 'foobar'
    service_map = {'rbc' => foobar_rbc, 'ymail' => foobar_ymail}
    service_map.each do |service,grid|
      obj = GridLock::Manager.new(service)
      obj.should_receive(:ask).exactly(2).times.and_return(password)
      result = obj.send(:generate_output)
      result.should == grid
      # Check that the outputs are different.
      if service == 'rbc'
        result.should_not == foobar_ymail
      end
    end
  end

  it 'should call generate_output and puts from display' do
      obj = GridLock::Manager.new('ymail')
      obj.should_receive(:generate_output).exactly(1).times
      obj.should_receive(:puts).and_return
      obj.display
  end
end

describe GridLock::TokenStream do
  it 'should have the correct letters set' do
    service = 'ymail.com'
    obj = GridLock::TokenStream.new('password', service)
    obj.class.letters[:cons].uniq.length.should == 20
    obj.class.letters[:vowels].uniq.length.should == 6
  end

  it 'should use SHA512 as the hash algorithm' do
    GridLock::TokenStream::HashAlg.should == 'sha512'
  end

  it 'should produce close to a uniform distribution of letters within cons and vowels' do
    service = 'ymail.com'
    obj = GridLock::TokenStream.new('password', service)
    h = Hash.new(0)
    Trials = 100000
    Trials.times do
      token = obj.yield_token
      token.each_char do |char|
        h[char] += 1
      end
    end
    h.each do |letter,count|
      if obj.class.letters[:vowels].include?(letter)
        # TODO: Make this a bit more statistically rigorous.
        # Note, we multiply by 1/2 because vowels and consonants are considered separately.
        count.should be_within(800).
          of(0.5 * Trials * GridLock::TokenStream::TokenSize / obj.class.letters[:vowels].length)
      else
        count.should be_within(800).
          of(0.5 * Trials * GridLock::TokenStream::TokenSize / obj.class.letters[:cons].length)
      end
    end
  end
end

