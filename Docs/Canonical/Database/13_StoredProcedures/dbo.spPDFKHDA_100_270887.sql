SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPDFKHDA_100_270887]                   
                  
AS

--cadu 100-269240
SET NOCOUNT ON          
--  SET NOCOUNT OFF   

select distinct UPPER(da.Num_Proc) Num_Proc,                       
 UPPER(nome_arquivo) nome_arquivo,                      
 UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC, 
--'Documentos' pasta,  
 replace(replace(case when po.Numero_PO = ''   then 'PONotFound'  else 
	(case when po.Numero_PO = '-' then 'PONotFound' else po.Numero_PO  end) end ,' ',''),'/','_')   pasta,
 DMS_Code  ,da.Id_DC     
 from doc_anexos DA with(nolock)                      
 Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null 
 left join vwPO PO with(nolock) on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 5
where      
DA.ID_DC in (10)   
and DA.Num_Proc in  
  (
  'IMCSR201704676BR',
'IMCSR201704677BR',
'IOCSR201709034BR',
'IOCSR201709036BR',
'IMCSR201710015BR',
'IMCSR201710015BR',
'IMCSR201710468BR',
'IMCSR201712349BR',
'IMCSR201801687BR',
'IMCSR201802088BR',
'IMCSR201803155BR',
'IMCSR201803155BR',
'IMCSR201803155BR',
'IMCSR201803155BR',
'IMCSR201803231BR',
'IMCSR201803231BR',
'IMCSR201803233BR',
'IMCSR201803233BR',
'IMCSR201804023BR',
'IMCSR201804023BR',
'IMCSR201804023BR',
'IMCSR201804023BR',
'IMCSR201804106BR',
'IMCSR201804106BR',
'IMCSR201804106BR',
'IMCSR201804106BR',
'IMCSR201804127BR',
'IMCSR201805104BR',
'IMCSR201805104BR',
'IMCSR201805104BR',
'IMCSR201805856BR',
'IMCSR201805857BR',
'IMCSR201805857BR',
'IMCSR201805863BR',
'IMCSR201805876BR',
'IMCSR201805876BR',
'IMCSR201805877BR',
'IMCSR201805877BR',
'IMCSR201806251BR',
'IMCSR201806251BR',
'IMCSR201806249BR',
'IMCSR201806249BR',
'IMCSR201806127BR',
'IMCSR201807264BR',
'IMCSR201808024BR',
'IMCSR201808024BR',
'IMCSR201808025BR',
'IMCSR201808025BR',
'IMCSR201808026BR',
'IMCSR201808026BR',
'IMCSR201808027BR',
'IMCSR201808027BR',
'IMCSR201808028BR',
'IMCSR201808028BR',
'IMCSR201808029BR',
'IMCSR201808029BR',
'IMCSR201808030BR',
'IMCSR201808030BR',
'IMCSR201808172BR',
'IMCSR201808172BR',
'IMCSR201808756BR',
'IMCSR201808756BR',
'IMCSR201809146BR',
'IMCSR201809146BR',
'IMCSR201808755BR',
'IMCSR201808755BR',
'IMCSR201808758BR',
'IMCSR201808758BR',
'IMCSR201808759BR',
'IMCSR201808759BR',
'IMCSR201808762BR',
'IMCSR201808762BR',
'IMCSR201808763BR',
'IMCSR201808763BR',
'IMCSR201808764BR',
'IMCSR201808764BR',
'IMCSR201808765BR',
'IMCSR201808765BR',
'IMCSR201808766BR',
'IMCSR201808766BR',
'IMCSR201808767BR',
'IMCSR201808767BR',
'IMCSR201808769BR',
'IMCSR201808769BR',
'IMCSR201808768BR',
'IMCSR201808768BR',
'IMCSR201811576BR',
'IMCSR201811576BR',
'IMCSR201811577BR',
'IMCSR201811577BR',
'IMCSR201811578BR',
'IMCSR201811578BR',
'IMCSR201811580BR',
'IMCSR201811580BR',
'IMCSR201811581BR',
'IMCSR201811581BR',
'IMCSR201811582BR',
'IMCSR201811582BR',
'IMCSR201811583BR',
'IMCSR201811583BR',
'IMCSR201811584BR',
'IMCSR201811584BR',
'IMCSR201811585BR',
'IMCSR201811585BR',
'IMCSR201811586BR',
'IMCSR201811586BR',
'IMCSR201811178BR',
'IMCSR201812044BR',
'IMCSR201812044BR',
'IMCSR201812042BR',
'IMCSR201812042BR',
'IMCSR201812042BR',
'IMCSR201901238BR',
'IMCSR201901238BR',
'IMCSR201901239BR',
'IMCSR201901239BR',
'IMCSR201901250BR',
'IMCSR201901250BR',
'IMCSR201901230BR',
'IMCSR201901230BR',
'IMCSR201901230BR',
'IMCSR201901254BR',
'IMCSR201901255BR',
'IMCSR201901823BR',
'IMCSR201901823BR',
'IMCSR201901821BR',
'IMCSR201901821BR',
'IMCSR201901820BR',
'IMCSR201901820BR',
'IMCSR201901825BR',
'IMCSR201901825BR',
'IACSR201802014BR',
'IACSR201802014BR',
'IACSR201703016BR',
'IACSR201703016BR',
'IACSR201712045BR',
'IACSR201712036BR',
'IACSR201712036BR',
'IACSR201801004BR',
'IACSR201801004BR',
'IACSR201810050BR',
'IACSR201810050BR',
'IACSR201902012BR',
'IACSR201902012BR',
'IMCSR201612278BR',
'IMCSR201711058BR',
'IMCSR201806406BR',
'IMCSR201704423BR',
'IMCSR201704403BR',
'IMCSR201710414BR',
'IMCSR201710459BR',
'IMCSR201710459BR',
'IMCSR201711229BR',
'IMCSR201711229BR',
'IMCSR201711230BR',
'IMCSR201711230BR',
'IMCSR201711231BR',
'IMCSR201711231BR',
'IMCSR201711232BR',
'IMCSR201711232BR',
'IMCSR201711234BR',
'IMCSR201711234BR',
'IMCSR201711235BR',
'IMCSR201711235BR',
'IMCSR201711236BR',
'IMCSR201711236BR',
'IMCSR201711237BR',
'IMCSR201711237BR',
'IMCSR201712213BR',
'IMCSR201712213BR',
'IMCSR201712252BR',
'IMCSR201712252BR',
'IMCSR201712254BR',
'IMCSR201712254BR',
'IMCSR201712257BR',
'IMCSR201712257BR',
'IMCSR201712258BR',
'IMCSR201712258BR',
'IMCSR201712260BR',
'IMCSR201712260BR',
'IMCSR201712261BR',
'IMCSR201712261BR',
'IMCSR201712262BR',
'IMCSR201712262BR',
'IMCSR201712263BR',
'IMCSR201712263BR',
'IMCSR201712264BR',
'IMCSR201712264BR',
'IACSR201802030BR',
'ACSR201802017BR',
'IMCSR201712359BR',
'IMCSR201712359BR',
'IMCSR201712363BR',
'IMCSR201712363BR',
'IMCSR201712363BR',
'IMCSR201712364BR',
'IMCSR201712364BR',
'IMCSR201712365BR',
'IMCSR201712365BR',
'IMCSR201712366BR',
'IMCSR201712366BR',
'IMCSR201712367BR',
'IMCSR201712368BR',
'IMCSR201712368BR',
'IMCSR201712371BR',
'IMCSR201712371BR',
'IMCSR201712373BR',
'IMCSR201712373BR',
'IMCSR201712374BR',
'IMCSR201712374BR',
'IMCSR201801640BR',
'IMCSR201801640BR',
'IMCSR201801641BR',
'IMCSR201801641BR',
'IMCSR201801642BR',
'IMCSR201801642BR',
'IMCSR201802078BR',
'IACSR201802033BR',
'IACSR201802034BR',
'IACSR201802035BR',
'IACSR201802036BR',
'MCSR201803272BR ',
'IMCSR201803136BR',
'IMCSR201803145BR',
'IACSR201803008BR',
'IMCSR201804167BR',
'IMCSR201804062BR',
'IMCSR201804062BR',
'IMCSR201804063BR',
'IMCSR201804063BR',
'IMCSR201804066BR',
'IMCSR201804066BR',
'IMCSR201804092BR',
'IMCSR201804291BR',
'IOCSR201805033BR',
'IOCSR201805033BR',
'IACSR201804031BR',
'IACSR201804031BR',
'IMCSR201805082BR',
'IMCSR201805401BR',
'IMCSR201805401BR',
'IMCSR201805806BR',
'IMCSR201806063BR',
'IMCSR201806063BR',
'IMCSR201806060BR',
'IMCSR201806060BR',
'IMCSR201806576BR',
'IMCSR201806536BR',
'IMCSR201806536BR',
'IMCSR201806536BR',
'IMCSR201807125BR',
'IMCSR201807125BR',
'IMCSR201807127BR',
'IMCSR201807127BR',
'IMCSR201807172BR',
'IMCSR201807172BR',
'IACSR201807026BR',
'IACSR201807029BR',
'IACSR201807030BR',
'IMCSR201807311BR',
'IMCSR201807640BR',
'IMCSR201807640BR',
'IMCSR201807477BR',
'IMCSR201807497BR',
'IMCSR201807497BR',
'IMCSR201807498BR',
'IMCSR201807498BR',
'IMCSR201807498BR',
'IMCSR201807498BR',
'IMCSR201807501BR',
'IMCSR201807511BR',
'IMCSR201807511BR',
'IMCSR201807513BR',
'IMCSR201807513BR',
'IMCSR201807518BR',
'IMCSR201807518BR',
'IMCSR201807524BR',
'IMCSR201807524BR',
'IACSR201808030BR',
'IACSR201808033BR',
'IACSR201808026BR',
'IMCSR201808445BR',
'IMCSR201808445BR',
'IACSR201808042BR',
'IACSR201808051BR',
'IACSR201808052BR',
'IACSR201808053BR',
'IACSR201808054BR',
'IACSR201808055BR',
'IACSR201808057BR',
'IACSR201808062BR',
'IACSR201808063BR',
'IACSR201808065BR',
'IACSR201808066BR',
'IMCSR201808474BR',
'IMCSR201808474BR',
'IMCSR201808646BR',
'IMCSR201808646BR',
'IMCSR201808648BR',
'IMCSR201808649BR',
'IMCSR201808649BR',
'IMCSR201808594BR',
'IMCSR201808594BR',
'IMCSR201808596BR',
'IMCSR201808596BR',
'IMCSR201808599BR',
'IMCSR201808599BR',
'IMCSR201808508BR',
'IMCSR201808508BR',
'IMCSR201808528BR',
'IMCSR201808528BR',
'IMCSR201808529BR',
'IMCSR201808529BR',
'IMCSR201808531BR',
'IMCSR201808531BR',
'IMCSR201808532BR',
'IMCSR201808532BR',
'IMCSR201808533BR',
'IMCSR201808533BR',
'IMCSR201808534BR',
'IMCSR201808534BR',
'IMCSR201808538BR',
'IMCSR201808538BR',
'IMCSR201808539BR',
'IMCSR201808539BR',
'IMCSR201808541BR',
'IMCSR201808541BR',
'IMCSR201808542BR',
'IMCSR201808542BR',
'IMCSR201808544BR',
'IMCSR201808544BR',
'IMCSR201808547BR',
'IMCSR201808547BR',
'IMCSR201808551BR',
'IMCSR201808551BR',
'IMCSR201808552BR',
'IMCSR201808552BR',
'IMCSR201808557BR',
'IMCSR201808557BR',
'IMCSR201808560BR',
'IMCSR201808560BR',
'IMCSR201808563BR',
'IMCSR201808563BR',
'IMCSR201808565BR',
'IMCSR201808565BR',
'IMCSR201808567BR',
'IMCSR201808567BR',
'IMCSR201808568BR',
'IMCSR201808568BR',
'IMCSR201808569BR',
'IMCSR201808569BR',
'IMCSR201808570BR',
'IMCSR201808570BR',
'IMCSR201808571BR',
'IMCSR201808571BR',
'IMCSR201808572BR',
'IMCSR201808572BR',
'IMCSR201808573BR',
'IMCSR201808573BR',
'IMCSR201808576BR',
'IMCSR201808576BR',
'IMCSR201808577BR',
'IMCSR201808577BR',
'IMCSR201808579BR',
'IMCSR201808579BR',
'IMCSR201810358BR',
'IACSR201810009BR',
'IACSR201810010BR',
'IACSR201808081BR',
'IACSR201808085BR',
'IACSR201810003BR',
'IACSR201810003BR',
'IMCSR201809530BR',
'IMCSR201809530BR',
'IMCSR201809531BR',
'IMCSR201809531BR',
'IMCSR201809532BR',
'IMCSR201809532BR',
'IMCSR201809533BR',
'IMCSR201809533BR',
'IMCSR201809535BR',
'IMCSR201809535BR',
'IMCSR201809536BR',
'IMCSR201809536BR',
'IMCSR201809537BR',
'IMCSR201809537BR',
'IMCSR201809538BR',
'IMCSR201809538BR',
'IMCSR201809539BR',
'IMCSR201809539BR',
'IMCSR201809540BR',
'IMCSR201809540BR',
'IMCSR201809541BR',
'IMCSR201809541BR',
'IMCSR201809542BR',
'IMCSR201809542BR',
'IMCSR201809543BR',
'IMCSR201809543BR',
'IMCSR201809544BR',
'IMCSR201809544BR',
'IMCSR201809545BR',
'IMCSR201809545BR',
'IMCSR201809546BR',
'IMCSR201809546BR',
'IACSR201810012BR',
'IMCSR201810012BR',
'IMCSR201810012BR',
'IMCSR201810056BR',
'IMCSR201810056BR',
'IMCSR201810058BR',
'IMCSR201810058BR',
'IMCSR201810066BR',
'IMCSR201810066BR',
'IMCSR201810069BR',
'IMCSR201810069BR',
'IMCSR201810071BR',
'IMCSR201810071BR',
'IMCSR201810072BR',
'IMCSR201810072BR',
'IMCSR201810844BR',
'IMCSR201810844BR',
'IACSR201810018BR',
'IMCSR201810278BR',
'IACSR201810025BR',
'IACSR201810030BR',
'IMCSR201810398BR',
'IMCSR201810398BR',
'IACSR201810038BR',
'IACSR201810039BR',
'IACSR201810040BR',
'IACSR201810041BR',
'IACSR201810044BR',
'IMCSR201810605BR',
'IMCSR201810605BR',
'IMCSR201810595BR',
'IMCSR201810595BR',
'IMCSR201810869BR',
'IMCSR201810869BR',
'IMCSR201810870BR',
'IMCSR201810870BR',
'IMCSR201810871BR',
'IMCSR201810871BR',
'IMCSR201810872BR',
'IMCSR201810872BR',
'IMCSR201810873BR',
'IMCSR201810873BR',
'IMCSR201810505BR',
'IMCSR201810505BR',
'IMCSR201810506BR',
'IMCSR201810506BR',
'IMCSR201810509BR',
'IMCSR201810509BR',
'IMCSR201810510BR',
'IMCSR201810510BR',
'IMCSR201810513BR',
'IMCSR201810513BR',
'IMCSR201810514BR',
'IMCSR201810514BR',
'IMCSR201810516BR',
'IMCSR201810516BR',
'IACSR201810048BR',
'IMCSR201810606BR',
'IMCSR201810606BR',
'IMCSR201810608BR',
'IMCSR201810608BR',
'IMCSR201810651BR',
'IMCSR201810651BR',
'IMCSR201810614BR',
'IMCSR201810614BR',
'IMCSR201810615BR',
'IMCSR201810615BR',
'IMCSR201810616BR',
'IMCSR201810616BR',
'IMCSR201810617BR',
'IMCSR201810617BR',
'IMCSR201810618BR',
'IMCSR201810618BR',
'IMCSR201810619BR',
'IMCSR201810619BR',
'IMCSR201810620BR',
'IMCSR201810620BR',
'IMCSR201810622BR',
'IMCSR201810622BR',
'IMCSR201810623BR',
'IMCSR201810623BR',
'IMCSR201810624BR',
'IMCSR201810624BR',
'IMCSR201810625BR',
'IMCSR201810625BR',
'IMCSR201810628BR',
'IMCSR201810628BR',
'IMCSR201810714BR',
'IMCSR201810714BR',
'IMCSR201810715BR',
'IMCSR201810715BR',
'IMCSR201810716BR',
'IMCSR201810716BR',
'IMCSR201810600BR',
'IMCSR201810600BR',
'IMCSR201811057BR',
'IMCSR201811057BR',
'IMCSR201811083BR',
'IMCSR201811083BR',
'IMCSR201811084BR',
'IMCSR201811084BR',
'IMCSR201811085BR',
'IMCSR201811085BR',
'IMCSR201811088BR',
'IMCSR201811088BR',
'IMCSR201811089BR',
'IMCSR201811089BR',
'IMCSR201811091BR',
'IMCSR201811091BR',
'IMCSR201811092BR',
'IMCSR201811092BR',
'IMCSR201811095BR',
'IMCSR201811095BR',
'IMCSR201811097BR',
'IMCSR201811097BR',
'IMCSR201811099BR',
'IMCSR201811099BR',
'IMCSR201811100BR',
'IMCSR201811100BR',
'IMCSR201811101BR',
'IMCSR201811101BR',
'IMCSR201811102BR',
'IMCSR201811102BR',
'IMCSR201811108BR',
'IMCSR201811108BR',
'IMCSR201811124BR',
'IMCSR201811124BR',
'IMCSR201811103BR',
'IMCSR201811103BR',
'IMCSR201811106BR',
'IMCSR201811106BR',
'IMCSR201811107BR',
'IMCSR201811107BR',
'IMCSR201811105BR',
'IMCSR201811105BR',
'IMCSR201811125BR',
'IMCSR201811125BR',
'IMCSR201811126BR',
'IMCSR201811126BR',
'IMCSR201811130BR',
'IMCSR201811130BR',
'IMCSR201811131BR',
'IMCSR201811131BR',
'IMCSR201811134BR',
'IMCSR201811134BR',
'IMCSR201811135BR',
'IMCSR201811135BR',
'IMCSR201811198BR',
'IMCSR201811198BR',
'IMCSR201811625BR',
'IMCSR201811625BR',
'IMCSR201811638BR',
'IMCSR201811638BR',
'IMCSR201811646BR',
'IMCSR201811646BR',
'IMCSR201901215BR',
'IMCSR201901215BR',
'IMCSR201901215BR',
'IMCSR201812250BR',
'IMCSR201812250BR',
'IMCSR201812511BR',
'IMCSR201812515BR',
'IACSR201901009BR',
'IMCSR201901595BR',
'IMCSR201901595BR',
'IMCSR201902510BR',
'IMCSR201802284BR',
'IMCSR201802284BR',
'IOCSR201710035BR',
'IMCSR201712322BR',
'IMCSR201712322BR',
'IMCSR201712356BR',
'IMCSR201712356BR',
'IMCSR201801421BR',
'IACSR201803043BR',
'IACSR201803043BR',
'IACSR201803043BR',
'IACSR201803043BR',
'IACSR201803043BR',
'IACSR201803043BR',
'IOCSR201805010BR',
'IOCSR201805016BR',
'IMCSR201808609BR',
'IMCSR201807496BR',
'IMCSR201808609BR',
'IMCSR201807496BR',
'IMCSR201808357BR',
'IMCSR201808357BR',
'IMCSR201808359BR',
'IMCSR201808359BR',
'IMCSR201808360BR',
'IMCSR201808360BR',
'IMCSR201808361BR',
'IMCSR201808361BR',
'IMCSR201808362BR',
'IMCSR201808362BR',
'IMCSR201808364BR',
'IMCSR201808364BR',
'IMCSR201808352BR',
'IMCSR201808352BR',
'IACSR201810004BR',
'IACSR201810004BR',
'IACSR201810004BR',
'IMCSR201808603BR',
'IMCSR201808603BR',
'IMCSR201808613BR',
'IMCSR201808613BR',
'IMCSR201808614BR',
'IMCSR201808614BR',
'IMCSR201808615BR',
'IMCSR201808615BR',
'IMCSR201808611BR',
'IMCSR201808611BR',
'IMCSR201808612BR',
'IMCSR201808612BR',
'IMCSR201808862BR',
'IMCSR201808862BR',
'IMCSR201810048BR',
'IOCSR201810011BR',
'IOCSR201810009BR',
'IOCSR201810010BR',
'IOCSR201810011BR',
'IOCSR201810019BR',
'IOCSR201810028BR',
'IOCSR201811007BR',
'IOCSR201810029BR',
'IOCSR201810020BR',
'IOCSR201810021BR',
'IOCSR201810022BR',
'IOCSR201810023BR',
'IOCSR201810024BR',
'IOCSR201810025BR',
'IOCSR201810026BR',
'IOCSR201810027BR',
'IMCSR201811235BR',
'IOCSR201811027BR',
'IOCSR201811028BR',
'IOCSR201811029BR',
'IOCSR201811031BR',
'IOCSR201811032BR',
'IOCSR201811033BR',
'IOCSR201811034BR',
'IOCSR201811035BR',
'IOCSR201811012BR',
'IOCSR201811017BR',
'IOCSR201811026BR',
'IMCSR201812076BR',
'IMCSR201812076BR',
'IMCSR201812077BR',
'IMCSR201812077BR',
'IMCSR201812078BR',
'IMCSR201812078BR',
'IOCSR201901005BR',
'IOCSR201901006BR',
'IOCSR201901007BR',
'IOCSR201901008BR',
'IMCSR201901222BR',
'IMCSR201901223BR',
'IMCSR201903439BR',
'IACSR201903032BR',
'IACSR201808013BR',
'IMCSR201803243BR',
'IMCSR201808604BR',
'IMCSR201803243BR',
'IMCSR201808604BR',
'IMCSR201803243BR'

  )                     

order by 1,4


SET NOCOUNT OFF 


--SET NOCOUNT ON          
----  SET NOCOUNT OFF   

--select distinct UPPER(da.Num_Proc) Num_Proc,                       
-- UPPER(nome_arquivo) nome_arquivo,                      
-- UPPER(da.Num_Proc + '_' + replace(replace(TC.Nome_DC,' ',''),'/','')) + '.pdf' NOME_DOC, 
--'Documentos' pasta,  
-- DMS_Code       
-- from doc_anexos DA with(nolock)                      
-- Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC and DMS_Code is not null 
--where                      
--   DA.Num_Proc in   ('IASPC202009015BR'
--					,'IASPC202009016BR'
--					,'IASPC202009017BR'
--					,'IASPC202010003BR'
--					,'IASPC202010006BR'
--					,'IASPC202010008BR'
--					,'IASPC202010009BR'
--					,'IMSPC202008001BR'
--					,'IMSPC202008009BR'
--					,'IMSPC202008010BR'
--					,'IMSPC202008011BR'
--					,'IMSPC202008013BR'
--					,'IMSPC202008015BR'
--					,'IMSPC202008016BR'
--					,'IMSPC202008019BR'
--					,'IMSPC202008020BR'
--					,'IMSPC202008021BR'
--					,'IMSPC202008024BR'
--					,'IMSPC202008026BR'
--					,'IMSPC202009003BR'
--					,'IMSPC202009004BR'
--					,'IMSPC202009005BR'
--					,'IMSPC202009007BR'
--					,'IMSPC202009008BR'
--					,'IMSPC202009009BR'
--					,'IMSPC202009015BR'
--					,'IMSPC202009017BR'
--					,'IMSPC202009018BR'
--					,'IMSPC202009021BR'
--					,'IMSPC202009022BR'
--					,'IMSPC202009025BR'
--					,'IMSPC202009026BR'
--					,'IMSPC202009028BR'
--					,'IMSPC202009029BR'
--					,'IMSPC202009030BR'
--					,'IMSPC202009032BR'
--					,'IMSPC202009037BR'
--					,'IMSPC202009038BR'
--					,'IMSPC202009039BR'
--					,'IMSPC202009015BR'
--					,'IMSPC202009016BR'
--					,'IMSPC202009017BR'
--					,'IMSPC202010003BR'
--					,'IMSPC202010006BR'
--					,'IMSPC202010008BR'
--					,'IMSPC202010009BR'
--					,'IMSPC202008001BR'
--					,'IMSPC202008009BR'
--					,'IMSPC202008010BR'
--					,'IMSPC202008011BR'
--					,'IMSPC202008013BR'
--					,'IMSPC202008015BR'
--					,'IMSPC202008016BR'
--					,'IMSPC202008019BR'
--					,'IMSPC202008020BR'
--					,'IMSPC202008021BR'
--					,'IMSPC202008024BR'
--					,'IMSPC202008026BR'
--					,'IMSPC202009003BR'
--					,'IMSPC202009004BR'
--					,'IMSPC202009005BR'
--					,'IMSPC202009007BR'
--					,'IMSPC202009008BR'
--					,'IMSPC202009009BR'
--					,'IMSPC202009015BR'
--					,'IMSPC202009017BR'
--					,'IMSPC202009018BR'
--					,'IMSPC202009021BR'
--					,'IMSPC202009022BR'
--					,'IMSPC202009025BR'
--					,'IMSPC202009026BR'
--					,'IMSPC202009028BR'
--					,'IMSPC202009029BR'
--					,'IMSPC202009030BR'
--					,'IMSPC202009032BR'
--					,'IMSPC202009037BR'
--					,'IMSPC202009038BR'
--					,'IMSPC202009039BR')                     
--	and TC.ID_DC in (10,195,040,075,5)                   

--SET NOCOUNT OFF   

--select distinct      
          
-- SUBSTRING(upper(DA.Num_Proc),1,2) as pasta        
-- ,upper(DA.Num_Proc) as pasta2        
-- ,UPPER(nome_arquivo) nome_arquivo                        
-- ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC        
-- ,da.Id_DC                  
-- from vwClienteALLJOBS V (nolock)                   
-- inner join doc_anexos DA with(nolock)           
--	on V.Num_Proc = DA.Num_Proc                 
-- inner Join Tipo_DoC_Cliente TC (nolock)           
--	on TC.id_dc=da.Id_DC          
-- where  cd_cliente in (	select cd_pes 
--						from Pessoa_LLP         
--						where Cd_Pes_Grupo in (select Cd_Pes 
--												from Pessoa  
--												where Apelido in ( 'GRUPO GIVAUDAN','GRUPO GIVAUDAN AROMA')        
--												)    
--						)
--and DA.id_dc = 5  


  
   



/*
--===================================================================================================================    
--============================ Anual envio de documentos - Bruno brianezze ==========================================    
--===================================================================================================================    
 /*  
select * from Tipo_Tarefas  where nome_task = 'GR Efetivo'  
select * from Tipo_Tarefas  where nome_task = 'Averbação' and cd_pes_grupo = '10017'  
*/  

create table #tmp_num_proc           
(               
num_proc varchar(16) COLLATE Latin1_General_CI_AI           
)             
         
if 1 = 1         
begin     
insert into #tmp_num_proc select  'IMOCV201711005BR'
insert into #tmp_num_proc select  'IMOCV201801013BR'
insert into #tmp_num_proc select  'IMOCV201801013BR'
insert into #tmp_num_proc select  'IMOCV201801009BR'
insert into #tmp_num_proc select  'IMOCV201801012BR'
insert into #tmp_num_proc select  'IMOCV201801012BR'
insert into #tmp_num_proc select  'IMOCV201801004BR'
insert into #tmp_num_proc select  'IMOCV201801004BR'
insert into #tmp_num_proc select  'IMOCV201711009BR'
insert into #tmp_num_proc select  'IMOCV201712006BR'
insert into #tmp_num_proc select  'IMOCV201801005BR'
insert into #tmp_num_proc select  'IMOCV201801002BR'
insert into #tmp_num_proc select  'IMOCV201801020BR'
insert into #tmp_num_proc select  'IMOCV201802001BR'
insert into #tmp_num_proc select  'IMOCV201803032BR'
insert into #tmp_num_proc select  'IAOCV201802003BR'
insert into #tmp_num_proc select  'IAOCV201803003BR'
insert into #tmp_num_proc select  'IMOCV201802004BR'
insert into #tmp_num_proc select  'IMOCV201802004BR'
insert into #tmp_num_proc select  'IMOCV201803019BR'
insert into #tmp_num_proc select  'IMOCV201803019BR'
insert into #tmp_num_proc select  'IMOCV201710006BR'
insert into #tmp_num_proc select  'IAOCV201803004BR'
insert into #tmp_num_proc select  'IMOCV201801016BR'
insert into #tmp_num_proc select  'IMOCV201801019BR'
insert into #tmp_num_proc select  'IMOCV201802002BR'
insert into #tmp_num_proc select  'IMOCV201803007BR'
insert into #tmp_num_proc select  'IAOCV201712001BR'
insert into #tmp_num_proc select  'IAOCV201804003BR'
insert into #tmp_num_proc select  'IMOCV201803023BR'
insert into #tmp_num_proc select  'IMOCV201803011BR'
insert into #tmp_num_proc select  'IAOCV201804001BR'
insert into #tmp_num_proc select  'IMOCV201801014BR'
insert into #tmp_num_proc select  'IAOCV201712003BR'
insert into #tmp_num_proc select  'IMOCV201803004BR'
insert into #tmp_num_proc select  'IMOCV201801015BR'
insert into #tmp_num_proc select  'IMOCV201801015BR'
insert into #tmp_num_proc select  'IMOCV201803022BR'
insert into #tmp_num_proc select  'IMOCV201803047BR'
insert into #tmp_num_proc select  'IMOCV201801003BR'
insert into #tmp_num_proc select  'IAOCV201804004BR'
insert into #tmp_num_proc select  'IMOCV201803029BR'
insert into #tmp_num_proc select  'IMOCV201803006BR'
insert into #tmp_num_proc select  'IMOCV201803009BR'
insert into #tmp_num_proc select  'IMOCV201803013BR'
insert into #tmp_num_proc select  'IMOCV201803048BR'
insert into #tmp_num_proc select  'IMOCV201803051BR'
insert into #tmp_num_proc select  'IMOCV201804004BR'
insert into #tmp_num_proc select  'IMOCV201804004BR'
insert into #tmp_num_proc select  'IMOCV201802008BR'
insert into #tmp_num_proc select  'IMOCV201802008BR'
insert into #tmp_num_proc select  'IMOCV201802006BR'
insert into #tmp_num_proc select  'IMOCV201802008BR'
insert into #tmp_num_proc select  'IMOCV201803018BR'
insert into #tmp_num_proc select  'IAOCV201805001BR'
insert into #tmp_num_proc select  'IAOCV201805001BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IAOCV201803002BR'
insert into #tmp_num_proc select  'IMOCV201801017BR'
insert into #tmp_num_proc select  'IMOCV201803030BR'
insert into #tmp_num_proc select  'IMOCV201803037BR'
insert into #tmp_num_proc select  'IMOCV201803043BR'
insert into #tmp_num_proc select  'IMOCV201803044BR'
insert into #tmp_num_proc select  'IMOCV201804009BR'
insert into #tmp_num_proc select  'IAOCV201803001BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201803016BR'
insert into #tmp_num_proc select  'IMOCV201803038BR'
insert into #tmp_num_proc select  'IMOCV201802007BR'
insert into #tmp_num_proc select  'IMOCV201802007BR'
insert into #tmp_num_proc select  'IAOCV201804002BR'
insert into #tmp_num_proc select  'IMOCV201803001BR'
insert into #tmp_num_proc select  'IMOCV201803052BR'
insert into #tmp_num_proc select  'IMOCV201803052BR'
insert into #tmp_num_proc select  'IMOCV201802009BR'
insert into #tmp_num_proc select  'IAOCV201805005BR'
insert into #tmp_num_proc select  'IAOCV201805005BR'
insert into #tmp_num_proc select  'IMOCV201803008BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IAOCV201805003BR'
insert into #tmp_num_proc select  'IMOCV201803005BR'
insert into #tmp_num_proc select  'IAOCV201709002BR'
insert into #tmp_num_proc select  'IMOCV201804014BR'
insert into #tmp_num_proc select  'IMOCV201805016BR'
insert into #tmp_num_proc select  'IMOCV201804015BR'
insert into #tmp_num_proc select  'IMOCV201802003BR'
insert into #tmp_num_proc select  'IMOCV201802003BR'
insert into #tmp_num_proc select  'IMOCV201805015BR'
insert into #tmp_num_proc select  'IMOCV201805015BR'
insert into #tmp_num_proc select  'IMOCV201804008BR'
insert into #tmp_num_proc select  'IMOCV201805006BR'
insert into #tmp_num_proc select  'IMOCV201805013BR'
insert into #tmp_num_proc select  'IMOCV201803025BR'
insert into #tmp_num_proc select  'IMOCV201803010BR'
insert into #tmp_num_proc select  'IMOCV201803003BR'
insert into #tmp_num_proc select  'IMOCV201805008BR'
insert into #tmp_num_proc select  'IMOCV201805009BR'
insert into #tmp_num_proc select  'IMOCV201806002BR'
insert into #tmp_num_proc select  'IMOCV201804006BR'
insert into #tmp_num_proc select  'IAOCV201805006BR'
insert into #tmp_num_proc select  'IAOCV201805006BR'
insert into #tmp_num_proc select  'IAOCV201805006BR'
insert into #tmp_num_proc select  'IMOCV201803039BR'
insert into #tmp_num_proc select  'IMOCV201803039BR'
insert into #tmp_num_proc select  'IMOCV201804002BR'
insert into #tmp_num_proc select  'IMOCV201804003BR'
insert into #tmp_num_proc select  'IMOCV201803027BR'
insert into #tmp_num_proc select  'IMOCV201805005BR'
insert into #tmp_num_proc select  'IMOCV201805005BR'
insert into #tmp_num_proc select  'IMOCV201805005BR'
insert into #tmp_num_proc select  'IAOCV201805004BR'
insert into #tmp_num_proc select  'IAOCV201807001BR'
insert into #tmp_num_proc select  'IMOCV201803017BR'
insert into #tmp_num_proc select  'IMOCV201804012BR'
insert into #tmp_num_proc select  'IMOCV201803026BR'
insert into #tmp_num_proc select  'IMOCV201806003BR'
insert into #tmp_num_proc select  'IMOCV201803002BR'
insert into #tmp_num_proc select  'IMOCV201803035BR'
insert into #tmp_num_proc select  'IMOCV201807003BR'
insert into #tmp_num_proc select  'IAOCV201807006BR'
insert into #tmp_num_proc select  'IMOCV201804001BR'
insert into #tmp_num_proc select  'IAOCV201805002BR'
insert into #tmp_num_proc select  'IMOCV201805007BR'
insert into #tmp_num_proc select  'IMOCV201805001BR'
insert into #tmp_num_proc select  'IAOCV201807004BR'
insert into #tmp_num_proc select  'IAOCV201807004BR'
insert into #tmp_num_proc select  'IMOCV201803021BR'
insert into #tmp_num_proc select  'IMOCV201803021BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201808001BR'
insert into #tmp_num_proc select  'IMOCV201803040BR'
insert into #tmp_num_proc select  'IMOCV201805002BR'
insert into #tmp_num_proc select  'IMOCV201807001BR'
insert into #tmp_num_proc select  'IAOCV201808003BR'
insert into #tmp_num_proc select  'IMOCV201805014BR'
insert into #tmp_num_proc select  'IMOCV201803033BR'
insert into #tmp_num_proc select  'IMOCV201804005BR'
insert into #tmp_num_proc select  'IMOCV201803041BR'
insert into #tmp_num_proc select  'IMOCV201805003BR'
insert into #tmp_num_proc select  'IMOCV201804010BR'
insert into #tmp_num_proc select  'IMOCV201805011BR'
insert into #tmp_num_proc select  'IMOCV201807004BR'
insert into #tmp_num_proc select  'IMOCV201804013BR'
insert into #tmp_num_proc select  'IMOCV201805011BR'
insert into #tmp_num_proc select  'IMOCV201805011BR'
insert into #tmp_num_proc select  'IAOCV201806001BR'
insert into #tmp_num_proc select  'IAOCV201806001BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808002BR'
insert into #tmp_num_proc select  'IAOCV201808004BR'
insert into #tmp_num_proc select  'IMOCV201808004BR'
insert into #tmp_num_proc select  'IMOCV201808003BR'
insert into #tmp_num_proc select  'IMOCV201808005BR'
insert into #tmp_num_proc select  'IMOCV201808002BR'
insert into #tmp_num_proc select  'IMOCV201803020BR'
insert into #tmp_num_proc select  'IMOCV201804007BR'
insert into #tmp_num_proc select  'IMOCV201809004BR'
insert into #tmp_num_proc select  'IAOCV201809002BR'
insert into #tmp_num_proc select  'IMOCV201803012BR'
insert into #tmp_num_proc select  'IMOCV201809002BR'
insert into #tmp_num_proc select  'IMOCV201809003BR'
insert into #tmp_num_proc select  'IMOCV201808007BR'
insert into #tmp_num_proc select  'IMOCV201809001BR'
insert into #tmp_num_proc select  'IMOCV201804011BR'
insert into #tmp_num_proc select  'IMOCV201809005BR'
insert into #tmp_num_proc select  'IMOCV201805010BR'
insert into #tmp_num_proc select  'IAOCV201807002BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IOOCV201809001BR'
insert into #tmp_num_proc select  'IMOCV201802005BR'
insert into #tmp_num_proc select  'IMOCV201802005BR'
insert into #tmp_num_proc select  'IMOCV201810002BR'
insert into #tmp_num_proc select  'IMOCV201809011BR'
insert into #tmp_num_proc select  'IMOCV201808001BR'
insert into #tmp_num_proc select  'IMOCV201808001BR'
insert into #tmp_num_proc select  'IAOCV201810002BR'
insert into #tmp_num_proc select  'IMOCV201810001BR'
insert into #tmp_num_proc select  'IMOCV201809025BR'
insert into #tmp_num_proc select  'IMOCV201809024BR'
insert into #tmp_num_proc select  'IAOCV201810003BR'
insert into #tmp_num_proc select  'IMOCV201809009BR'
insert into #tmp_num_proc select  'IMOCV201809021BR'
insert into #tmp_num_proc select  'IMOCV201809021BR'
insert into #tmp_num_proc select  'IMOCV201809021BR'
insert into #tmp_num_proc select  'IMOCV201809023BR'
insert into #tmp_num_proc select  'IMOCV201809023BR'
insert into #tmp_num_proc select  'IMOCV201809007BR'
insert into #tmp_num_proc select  'IMOCV201806001BR'
insert into #tmp_num_proc select  'IMOCV201806001BR'
insert into #tmp_num_proc select  'IMOCV201806001BR'
insert into #tmp_num_proc select  'IMOCV201809020BR'
insert into #tmp_num_proc select  'IMOCV201809012BR'
insert into #tmp_num_proc select  'IMOCV201809013BR'
insert into #tmp_num_proc select  'IMOCV201809018BR'
insert into #tmp_num_proc select  'IMOCV201810005BR'
insert into #tmp_num_proc select  'IMOCV201810008BR'
insert into #tmp_num_proc select  'IMOCV201810007BR'
insert into #tmp_num_proc select  'IMOCV201810008BR'
insert into #tmp_num_proc select  'IMOCV201810008BR'
insert into #tmp_num_proc select  'IMOCV201809017BR'
insert into #tmp_num_proc select  'IMOCV201810007BR'
insert into #tmp_num_proc select  'IMOCV201810012BR'
insert into #tmp_num_proc select  'IMOCV201810021BR'
insert into #tmp_num_proc select  'IMOCV201810003BR'
insert into #tmp_num_proc select  'IMOCV201810012BR'
insert into #tmp_num_proc select  'IAOCV201811001BR'
insert into #tmp_num_proc select  'IMOCV201810031BR'
insert into #tmp_num_proc select  'IMOCV201811004BR'
insert into #tmp_num_proc select  'IMOCV201809022BR'
insert into #tmp_num_proc select  'IMOCV201809022BR'
insert into #tmp_num_proc select  'IMOCV201810027BR'
insert into #tmp_num_proc select  'IMOCV201808006BR'
insert into #tmp_num_proc select  'IMOCV201810030BR'
insert into #tmp_num_proc select  'IMOCV201809008BR'
insert into #tmp_num_proc select  'IMOCV201810016BR'
insert into #tmp_num_proc select  'IMOCV201810023BR'
insert into #tmp_num_proc select  'IMOCV201810018BR'
insert into #tmp_num_proc select  'IMOCV201809015BR'
insert into #tmp_num_proc select  'IMOCV201810026BR'
insert into #tmp_num_proc select  'IAOCV201810004BR'
insert into #tmp_num_proc select  'IMOCV201809010BR'
insert into #tmp_num_proc select  'IMOCV201810004BR'
insert into #tmp_num_proc select  'IMOCV201810004BR'
insert into #tmp_num_proc select  'IAOCV201811007BR'
insert into #tmp_num_proc select  'IAOCV201811004BR'
insert into #tmp_num_proc select  'IAOCV201811003BR'
insert into #tmp_num_proc select  'IAOCV201811003BR'
insert into #tmp_num_proc select  'IMOCV201805012BR'
insert into #tmp_num_proc select  'IMOCV201810011BR'
insert into #tmp_num_proc select  'IMOCV201810024BR'
insert into #tmp_num_proc select  'IMOCV201810017BR'
insert into #tmp_num_proc select  'IMOCV201809019BR'
insert into #tmp_num_proc select  'IMOCV201812002BR'
insert into #tmp_num_proc select  'IMOCV201812002BR'
insert into #tmp_num_proc select  'IMOCV201812001BR'
insert into #tmp_num_proc select  'IMOCV201810028BR'
insert into #tmp_num_proc select  'IAOCV201812003BR'
insert into #tmp_num_proc select  'IMOCV201810013BR'
insert into #tmp_num_proc select  'IAOCV201811009BR'
insert into #tmp_num_proc select  'IMOCV201810019BR'
insert into #tmp_num_proc select  'IAOCV201812001BR'
insert into #tmp_num_proc select  'IMOCV201810009BR'
insert into #tmp_num_proc select  'IMOCV201810025BR'
insert into #tmp_num_proc select  'IMOCV201809006BR'
insert into #tmp_num_proc select  'IMOCV201809014BR'
insert into #tmp_num_proc select  'IMOCV201811005BR'
insert into #tmp_num_proc select  'IMOCV201809016BR'
insert into #tmp_num_proc select  'IAOCV201812004BR'
insert into #tmp_num_proc select  'IMOCV201810022BR'
insert into #tmp_num_proc select  'IMOCV201810022BR'
insert into #tmp_num_proc select  'IMOCV201810006BR'
insert into #tmp_num_proc select  'IMOCV201810006BR'
insert into #tmp_num_proc select  'IMOCV201810006BR'
insert into #tmp_num_proc select  'IMOCV201810020BR'
insert into #tmp_num_proc select  'IAOCV201812005BR'
insert into #tmp_num_proc select  'IMOCV201811002BR'
insert into #tmp_num_proc select  'IMOCV201803015BR'
insert into #tmp_num_proc select  'IMOCV201810010BR'
insert into #tmp_num_proc select  'IMOCV201811010BR'
insert into #tmp_num_proc select  'IMOCV201811011BR'
insert into #tmp_num_proc select  'IMOCV201811009BR'
insert into #tmp_num_proc select  'IMOCV201811008BR'
insert into #tmp_num_proc select  'IMOCV201810029BR'
insert into #tmp_num_proc select  'IAOCV201901012BR'
insert into #tmp_num_proc select  'IMOCV201811007BR'
insert into #tmp_num_proc select  'IAOCV201811008BR'
insert into #tmp_num_proc select  'IAOCV201901013BR'
insert into #tmp_num_proc select  'IAOCV201810001BR'
insert into #tmp_num_proc select  'IAOCV201901007BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901015BR'
insert into #tmp_num_proc select  'IMOCV201803014BR'
insert into #tmp_num_proc select  'IAOCV201811005BR'
insert into #tmp_num_proc select  'IAOCV201902003BR'
insert into #tmp_num_proc select  'IMOCV201812005BR'
insert into #tmp_num_proc select  'IAOCV201901001BR'
insert into #tmp_num_proc select  'IAOCV201901001BR'
insert into #tmp_num_proc select  'IAOCV201901001BR'
insert into #tmp_num_proc select  'IAOCV201901008BR'
insert into #tmp_num_proc select  'IMOCV201901002BR'
insert into #tmp_num_proc select  'IMOCV201901002BR'
insert into #tmp_num_proc select  'IMOCV201901003BR'
insert into #tmp_num_proc select  'IMOCV201901003BR'
insert into #tmp_num_proc select  'IAOCV201901002BR'
insert into #tmp_num_proc select  'IMOCV201901021BR'
insert into #tmp_num_proc select  'IMOCV201901021BR'
insert into #tmp_num_proc select  'IMOCV201901021BR'
insert into #tmp_num_proc select  'IMOCV201812006BR'
insert into #tmp_num_proc select  'IMOCV201901015BR'
insert into #tmp_num_proc select  'IAOCV201901005BR'
insert into #tmp_num_proc select  'IAOCV201902004BR'
insert into #tmp_num_proc select  'IAOCV201901005BR'
insert into #tmp_num_proc select  'IAOCV201902004BR'
insert into #tmp_num_proc select  'IAOCV201902007BR'
insert into #tmp_num_proc select  'IMOCV201901005BR'
insert into #tmp_num_proc select  'IMOCV201901022BR'
insert into #tmp_num_proc select  'IMOCV201901017BR'
insert into #tmp_num_proc select  'IMOCV201810014BR'
insert into #tmp_num_proc select  'IMOCV201901008BR'
insert into #tmp_num_proc select  'IMOCV201901008BR'
insert into #tmp_num_proc select  'IMOCV201901011BR'
insert into #tmp_num_proc select  'IAOCV201902006BR'
insert into #tmp_num_proc select  'IAOCV201902006BR'
insert into #tmp_num_proc select  'IMOCV201901009BR'
insert into #tmp_num_proc select  'IMOCV201903001BR'
insert into #tmp_num_proc select  'IMOCV201901006BR'
insert into #tmp_num_proc select  'IMOCV201901016BR'
insert into #tmp_num_proc select  'IMOCV201902002BR'
insert into #tmp_num_proc select  'IMOCV201901013BR'
insert into #tmp_num_proc select  'IMOCV201901018BR'
insert into #tmp_num_proc select  'IMOCV201901013BR'
insert into #tmp_num_proc select  'IMOCV201901013BR'
insert into #tmp_num_proc select  'IAOCV201903004BR'
insert into #tmp_num_proc select  'IMOCV201903004BR'
insert into #tmp_num_proc select  'IAOCV201901011BR'
insert into #tmp_num_proc select  'IMOCV201902001BR'
insert into #tmp_num_proc select  'IMOCV201902006BR'
insert into #tmp_num_proc select  'IMOCV201902001BR'
insert into #tmp_num_proc select  'IMOCV201901014BR'
insert into #tmp_num_proc select  'IMOCV201902009BR'
insert into #tmp_num_proc select  'IMOCV201902005BR'
insert into #tmp_num_proc select  'IMOCV201902003BR'
insert into #tmp_num_proc select  'IMOCV201901007BR'
insert into #tmp_num_proc select  'IMOCV201902013BR'
insert into #tmp_num_proc select  'IAOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201904001BR'
insert into #tmp_num_proc select  'IMOCV201901010BR'
insert into #tmp_num_proc select  'IMOCV201902016BR'
insert into #tmp_num_proc select  'IMOCV201902016BR'
insert into #tmp_num_proc select  'IMOCV201902016BR'
insert into #tmp_num_proc select  'IAOCV201901003BR'
insert into #tmp_num_proc select  'IAOCV201901003BR'
insert into #tmp_num_proc select  'IAOCV201904002BR'
insert into #tmp_num_proc select  'IMOCV201903006BR'
insert into #tmp_num_proc select  'IMOCV201902010BR'
insert into #tmp_num_proc select  'IMOCV201903005BR'
insert into #tmp_num_proc select  'IAOCV201902002BR'
insert into #tmp_num_proc select  'IAOCV201812002BR'
insert into #tmp_num_proc select  'IAOCV201901010BR'
insert into #tmp_num_proc select  'IAOCV201901006BR'
insert into #tmp_num_proc select  'IMOCV201902015BR'
insert into #tmp_num_proc select  'IAOCV201811002BR'
insert into #tmp_num_proc select  'IAOCV201811002BR'
insert into #tmp_num_proc select  'IAOCV201903001BR'
insert into #tmp_num_proc select  'IAOCV201904009BR'
insert into #tmp_num_proc select  'IMOCV201901012BR'
insert into #tmp_num_proc select  'IMOCV201902004BR'
insert into #tmp_num_proc select  'IAOCV201904003BR'
insert into #tmp_num_proc select  'IMOCV201902008BR'
insert into #tmp_num_proc select  'IMOCV201904012BR'
insert into #tmp_num_proc select  'IMOCV201902011BR'
insert into #tmp_num_proc select  'IAOCV201901009BR'
insert into #tmp_num_proc select  'IMOCV201902014BR'
insert into #tmp_num_proc select  'IMOCV201903008BR'
insert into #tmp_num_proc select  'IMOCV201904011BR'
insert into #tmp_num_proc select  'IMOCV201902012BR'
insert into #tmp_num_proc select  'IAOCV201901014BR'
insert into #tmp_num_proc select  'IAOCV201901014BR'
insert into #tmp_num_proc select  'IAOCV201901014BR'
insert into #tmp_num_proc select  'IMOCV201904013BR'
insert into #tmp_num_proc select  'IAOCV201904008BR'
insert into #tmp_num_proc select  'IMOCV201903009BR'
insert into #tmp_num_proc select  'IMOCV201903009BR'
insert into #tmp_num_proc select  'IMOCV201903002BR'
insert into #tmp_num_proc select  'IAOCV201903007BR'
insert into #tmp_num_proc select  'IAOCV201904010BR'
insert into #tmp_num_proc select  'IAOCV201904010BR'
insert into #tmp_num_proc select  'IAOCV201905007BR'
insert into #tmp_num_proc select  'IMOCV201904001BR'
insert into #tmp_num_proc select  'IAOCV201905013BR'
insert into #tmp_num_proc select  'IAOCV201905013BR'
insert into #tmp_num_proc select  'IMOCV201903003BR'
insert into #tmp_num_proc select  'IMOCV201903007BR'
insert into #tmp_num_proc select  'IMOCV201903007BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201903006BR'
insert into #tmp_num_proc select  'IAOCV201904006BR'
insert into #tmp_num_proc select  'IMOCV201905008BR'
insert into #tmp_num_proc select  'IMOCV201905009BR'
insert into #tmp_num_proc select  'IAOCV201905004BR'
insert into #tmp_num_proc select  'IAOCV201905003BR'
insert into #tmp_num_proc select  'IAOCV201905005BR'
insert into #tmp_num_proc select  'IAOCV201905005BR'
insert into #tmp_num_proc select  'IMOCV201901019BR'
insert into #tmp_num_proc select  'IMOCV201902007BR'
insert into #tmp_num_proc select  'IMOCV201904017BR'
insert into #tmp_num_proc select  'IAOCV201904011BR'
insert into #tmp_num_proc select  'IMOCV201904015BR'
insert into #tmp_num_proc select  'IMOCV201904002BR'
insert into #tmp_num_proc select  'IMOCV201904015BR'
insert into #tmp_num_proc select  'IAOCV201906006BR'
insert into #tmp_num_proc select  'IAOCV201906006BR'
insert into #tmp_num_proc select  'IAOCV201905014BR'
insert into #tmp_num_proc select  'IAOCV201905014BR'
insert into #tmp_num_proc select  'IAOCV201905014BR'
insert into #tmp_num_proc select  'IAOCV201905001BR'
insert into #tmp_num_proc select  'IMOCV201904007BR'
insert into #tmp_num_proc select  'IAOCV201906008BR'
insert into #tmp_num_proc select  'IAOCV201906009BR'
insert into #tmp_num_proc select  'IAOCV201904012BR'
insert into #tmp_num_proc select  'IAOCV201906003BR'
insert into #tmp_num_proc select  'IAOCV201906011BR'
insert into #tmp_num_proc select  'IMOCV201905003BR'
insert into #tmp_num_proc select  'IMOCV201905018BR'
insert into #tmp_num_proc select  'IAOCV201905010BR'
insert into #tmp_num_proc select  'IMOCV201905005BR'
insert into #tmp_num_proc select  'IMOCV201906001BR'
insert into #tmp_num_proc select  'IMOCV201905007BR'
insert into #tmp_num_proc select  'IMOCV201905007BR'
insert into #tmp_num_proc select  'IAOCV201907001BR'
insert into #tmp_num_proc select  'IMOCV201905015BR'
insert into #tmp_num_proc select  'IMOCV201904006BR'
insert into #tmp_num_proc select  'IMOCV201904008BR'
insert into #tmp_num_proc select  'IMOCV201905012BR'
insert into #tmp_num_proc select  'IMOCV201904003BR'
insert into #tmp_num_proc select  'IAOCV201906001BR'
insert into #tmp_num_proc select  'IAOCV201906001BR'
insert into #tmp_num_proc select  'IAOCV201905008BR'
insert into #tmp_num_proc select  'IMOCV201905013BR'
insert into #tmp_num_proc select  'IMOCV201905016BR'
insert into #tmp_num_proc select  'IAOCV201905009BR'
insert into #tmp_num_proc select  'IAOCV201905015BR'
insert into #tmp_num_proc select  'IAOCV201906010BR'
insert into #tmp_num_proc select  'IAOCV201903003BR'
insert into #tmp_num_proc select  'IMOCV201905019BR'
insert into #tmp_num_proc select  'IMOCV201905017BR'
insert into #tmp_num_proc select  'IMOCV201905017BR'
insert into #tmp_num_proc select  'IMOCV201906005BR'
insert into #tmp_num_proc select  'IMOCV201906003BR'
insert into #tmp_num_proc select  'IAOCV201902001BR'
insert into #tmp_num_proc select  'IAOCV201907011BR'
insert into #tmp_num_proc select  'IMOCV201906008BR'
insert into #tmp_num_proc select  'IMOCV201904016BR'
insert into #tmp_num_proc select  'IMOCV201906013BR'
insert into #tmp_num_proc select  'IMOCV201906016BR'
insert into #tmp_num_proc select  'IMOCV201906015BR'
insert into #tmp_num_proc select  'IMOCV201906017BR'
insert into #tmp_num_proc select  'IMOCV201906017BR'
insert into #tmp_num_proc select  'IMOCV201906014BR'
insert into #tmp_num_proc select  'IMOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201904004BR'
insert into #tmp_num_proc select  'IAOCV201907010BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201908002BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IAOCV201906012BR'
insert into #tmp_num_proc select  'IMOCV201906011BR'
insert into #tmp_num_proc select  'IMOCV201906006BR'
insert into #tmp_num_proc select  'IMOCV201906019BR'
insert into #tmp_num_proc select  'IMOCV201906019BR'
insert into #tmp_num_proc select  'IAOCV201908003BR'
insert into #tmp_num_proc select  'IMOCV201907009BR'
insert into #tmp_num_proc select  'IMOCV201907009BR'
insert into #tmp_num_proc select  'IMOCV201907009BR'
insert into #tmp_num_proc select  'IAOCV201907007BR'
insert into #tmp_num_proc select  'IAOCV201908005BR'
insert into #tmp_num_proc select  'IAOCV201908005BR'
insert into #tmp_num_proc select  'IAOCV201908004BR'
insert into #tmp_num_proc select  'IMOCV201906007BR'
insert into #tmp_num_proc select  'IMOCV201908003BR'
insert into #tmp_num_proc select  'IMOCV201907006BR'
insert into #tmp_num_proc select  'IMOCV201906020BR'
insert into #tmp_num_proc select  'IMOCV201906020BR'
insert into #tmp_num_proc select  'IMOCV201907001BR'
insert into #tmp_num_proc select  'IMOCV201905014BR'
insert into #tmp_num_proc select  'IMOCV201908009BR'
insert into #tmp_num_proc select  'IMOCV201907010BR'
insert into #tmp_num_proc select  'IMOCV201906009BR'
insert into #tmp_num_proc select  'IMOCV201907003BR'
insert into #tmp_num_proc select  'IAOCV201905011BR'
insert into #tmp_num_proc select  'IAOCV201907005BR'
insert into #tmp_num_proc select  'IAOCV201907006BR'
insert into #tmp_num_proc select  'IAOCV201907009BR'
insert into #tmp_num_proc select  'IMOCV201907008BR'
insert into #tmp_num_proc select  'IAOCV201907004BR'
insert into #tmp_num_proc select  'IAOCV201907004BR'
insert into #tmp_num_proc select  'IMOCV201908006BR'
insert into #tmp_num_proc select  'IMOCV201908006BR'
insert into #tmp_num_proc select  'IMOCV201908006BR'

end
  
select distinct    
        
 SUBSTRING(upper(DA.Num_Proc),1,2) as pasta      
 ,upper(DA.Num_Proc) as pasta2      
 ,UPPER(nome_arquivo) nome_arquivo              
 --,UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,       
 ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
 ,da.Id_DC        
 --,ID_Status         
from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA (nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp (nolock)          
  on V.Num_Proc =  tp.Num_Proc  
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and da.ID_DC in ('10')    

  
SET NOCOUNT OFF      
*/














/*Verificação das quantidades do filtro    
    
 select       
   COUNT(DISTINCT upper(DA.Num_Proc)) as qtd_jobs    
  ,COUNT(da.Id_DC ) as qtd_doc    
     
        
  --select * from Tipo_DoC_Cliente      
        
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp        
  on V.Num_Proc =  tp.Num_Proc     
  inner join Campo_Processo cp         
  on V.Num_Proc =  cp.Num_Proc           
 --left join vwPO PO with(nolock)       
 -- on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1        
          
 where   ID_Status in (8,5)      
 and cd_cliente in (select cd_pes from Pessoa_LLP       
      where Cd_Pes_Grupo in       
       --(select Cd_Pes from Pessoa  where Apelido = 'GRUPO DOW')      
       --(select Cd_Pes from Pessoa  where Apelido = 'GRUPO CORTEVA')      
       (select Cd_Pes from Pessoa  where Apelido = 'GRUPO DUPONT')      
      )      
          
 and tp.id_Task=4        
 and tp.dt_Conclusao between '2019-01-01 00:00:00.000' and '2019-12-31 23:59:59.999'      
        
 and cp.Id_Campo = 32     
 and cp.Campo_Dados = 1    
*/      
    
  
        
        
/*  
--===================================================================================================================    
--============================ sob demanda lista de jobs ==========================================    
--===================================================================================================================    
create table #tmp_num_proc           
(               
num_proc varchar(16) COLLATE Latin1_General_CI_AI           
)             
         
if 1 = 1         
begin    
  
insert into #tmp_num_proc select  'EMCSR201902081BR'  
insert into #tmp_num_proc select  'EMCSR201901092BR'  
insert into #tmp_num_proc select  'EMCSR201902082BR'  
insert into #tmp_num_proc select  'EMCSR201902037BR'  
insert into #tmp_num_proc select  'EMCSR201903005BR'  
insert into #tmp_num_proc select  'EMCSR201902035BR'  
insert into #tmp_num_proc select  'EMCSR201903006BR'  
insert into #tmp_num_proc select  'EMCSR201902080BR'  
insert into #tmp_num_proc select  'EMCSR201903007BR'  
insert into #tmp_num_proc select  'EMCSR201903072BR'  
insert into #tmp_num_proc select  'EMCSR201902079BR'  
insert into #tmp_num_proc select  'EMCSR201903074BR'  
insert into #tmp_num_proc select  'EOCSR201910014BR'  
insert into #tmp_num_proc select  'EMCSR201903075BR'  
insert into #tmp_num_proc select  'EOCSR201908021BR'  
insert into #tmp_num_proc select  'EACSR201910005BR'  
insert into #tmp_num_proc select  'EMCSR201903076BR'  
insert into #tmp_num_proc select  'EMCSR201905040BR'  
insert into #tmp_num_proc select  'EMCSR201812095BR'  
insert into #tmp_num_proc select  'EACSR201907002BR'  
insert into #tmp_num_proc select  'EOCSR201902001BR'  
insert into #tmp_num_proc select  'EOCSR201907050BR'  
insert into #tmp_num_proc select  'EOCSR201907052BR'  
insert into #tmp_num_proc select  'EOCSR201907039BR'  
insert into #tmp_num_proc select  'EOCSR201907040BR'  
insert into #tmp_num_proc select  'EOCSR201908018BR'  
insert into #tmp_num_proc select  'EOCSR201910001BR'  
insert into #tmp_num_proc select  'EOCSR201908019BR'  
insert into #tmp_num_proc select  'EOCSR201909005BR'  
insert into #tmp_num_proc select  'EMCSR201904003BR'  
insert into #tmp_num_proc select  'EOCSR201909001BR'  
insert into #tmp_num_proc select  'EACSR201901003BR'  
insert into #tmp_num_proc select  'EOCSR201907042BR'  
insert into #tmp_num_proc select  'EOCSR201910002BR'  
insert into #tmp_num_proc select  'EOCSR201907001BR'  
insert into #tmp_num_proc select  'EOCSR201909021BR'  
insert into #tmp_num_proc select  'EACSR201910002BR'  
insert into #tmp_num_proc select  'EOCSR201909020BR'  
insert into #tmp_num_proc select  'EOCSR201907041BR'  
insert into #tmp_num_proc select  'EOCSR201911002BR'  
insert into #tmp_num_proc select  'EMCSR201911086BR'  
insert into #tmp_num_proc select  'EOCSR201911005BR'  
insert into #tmp_num_proc select  'EOCSR201911006BR'  
insert into #tmp_num_proc select  'EOCSR201911007BR'  
insert into #tmp_num_proc select  'EOCSR201908003BR'  
insert into #tmp_num_proc select  'EMCSR201905052BR'  
insert into #tmp_num_proc select  'EMCSR202002036BR'  
insert into #tmp_num_proc select  'EMCSR201904074BR'  
insert into #tmp_num_proc select  'EMCSR201904075BR'  
insert into #tmp_num_proc select  'EMCSR201905001BR'  
insert into #tmp_num_proc select  'EACSR201911001BR'  
insert into #tmp_num_proc select  'EMCSR201901069BR'  
insert into #tmp_num_proc select  'EMCSR201902106BR'  
insert into #tmp_num_proc select  'EMCSR202001072BR'  
  
    
end         
    
    
 select  DISTINCT      
  UPPER(nome_arquivo) nome_arquivo               
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
  ,da.Id_DC        
  ,ID_Status      
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and da.ID_DC in ('204')    
 */  
    
        
        
 /*    
--===================================================================================================================    
--============================ IMPO E EXPO - ==========================================    
--===================================================================================================================    
     
 select   --top 100      
  --case when po.Numero_PO = ''   then 'PONotFound'  else (case when po.Numero_PO = '-' then 'PONotFound' else po.Numero_PO  end) end         
  --,replacE(replacE(replace(ltrim(rtrim((numero_po  ))),' ',''),'/','-'),'\','') as pasta            
  case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' then 'Importação' else 'Exportação' end  as pasta      
  --,upper(DA.Num_Proc) as pasta2      
  ,UPPER(nome_arquivo) nome_arquivo              
  --,UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,       
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
  ,da.Id_DC        
  ,ID_Status      
        
  --select * from Tipo_DoC_Cliente      
        
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp        
  on V.Num_Proc =  tp.Num_Proc     
  inner join Campo_Processo cp         
  on V.Num_Proc =  cp.Num_Proc           
 --left join vwPO PO with(nolock)       
 -- on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1        
          
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and SUBSTRING(upper(DA.Num_Proc),1,1) = 'I'     
 and da.ID_DC in ('020','005')    
    
    
        
   union    
       
       
   select   --top 100      
  --case when po.Numero_PO = ''   then 'PONotFound'  else (case when po.Numero_PO = '-' then 'PONotFound' else po.Numero_PO  end) end         
  --,replacE(replacE(replace(ltrim(rtrim((numero_po  ))),' ',''),'/','-'),'\','') as pasta            
  case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' then 'Importação' else 'Exportação' end  as pasta        
  --,upper(DA.Num_Proc) as pasta2      
  ,UPPER(nome_arquivo) nome_arquivo              
  --,UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,       
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf' as NOME_DOC      
  ,da.Id_DC        
  ,ID_Status      
        
  --select * from Tipo_DoC_Cliente      
        
 from vwClienteALLJOBS V (nolock)                 
 inner join doc_anexos DA with(nolock)         
  on V.Num_Proc = DA.Num_Proc               
 inner Join Tipo_DoC_Cliente TC (nolock)         
  on TC.id_dc=da.Id_DC        
 inner join tarefas_processos tp        
  on V.Num_Proc =  tp.Num_Proc     
  inner join Campo_Processo cp         
  on V.Num_Proc =  cp.Num_Proc           
 --left join vwPO PO with(nolock)       
 -- on da.Num_Proc = PO.Num_proc and  PO.ID_DC = 1        
          
 where v.num_proc in (select num_proc from #tmp_num_proc )    
 and SUBSTRING(upper(DA.Num_Proc),1,1) = 'E'     
 and da.ID_DC in ('020','010')    
    
 ORDER BY       
  case when SUBSTRING(upper(DA.Num_Proc),1,1) = 'I' then 'Importação' else 'Exportação' end    
  ,UPPER(DA.Num_Proc+'_'+REPLACE(TC.nome_dc,' ','')) + '.pdf'    
        
 */       
        
        
        
      
--===================================================================================================================    
-- ===================================================================================================================    
    
        
        
 /*    
 --===================================================================================================================    
--============================ ENVIO DOCUMENTOS SISCOSERV TIAGO =====================================================    
--===================================================================================================================     
create table #tmp_num_proc           
(          
numero_po varchar(16) COLLATE Latin1_General_CI_AI           
,num_proc varchar(16) COLLATE Latin1_General_CI_AI           
)             
         
if 1 = 1         
begin        
 insert into #tmp_num_proc select  'xxxxxx','IMKRY201602008BR'    
 insert into #tmp_num_proc select  'xxxxxx','IMKRY201602004BR'    
 insert into #tmp_num_proc select  'xxxxxx','IMKRY201602013BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201708001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201709001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201710001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201712001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201801002BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201801003BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMAU201512001BR'    
 insert into #tmp_num_proc select  'xxxxxx','EACSR201703007BR'    
 insert into #tmp_num_proc select  'xxxxxx','EAMTE201707002BR'    
end         
           
                  
select          
numero_po as Numero_PO,             
replacE(replacE(replace(ltrim(rtrim((numero_po))),' ',''),'/','-'),'\','') as pasta,                 
UPPER(nome_arquivo) nome_arquivo,                  
-- UPPER('PO_' + replacE(replacE(replace((        
--numero_po         
-- ),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ isnull(smart_doc,'') + '.pdf') as NOME_DOC,           
UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,                         
da.Id_DC                 
from doc_anexos DA (nolock)                
inner Join Tipo_DoC_Cliente TC (nolock)         
 on TC.id_dc=da.Id_DC            
inner join #tmp_num_proc tmp (nolock)          
 on da.Num_Proc = tmp.num_proc           
 --inner join vwClienteALLJOBS a (nolock)         
 --on A.Num_Proc = DA.Num_Proc                  
 --inner join Pessoa P         
 --on P.cd_pes = A.cd_cliente                 
 --inner join tarefas_processos tp         
 --on da.Num_Proc =  tp.Num_Proc        
where         
--tp.id_Task=4        
--and tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000' and        
da.Id_DC in (15,20,44,74,149,177,178,180,181)         
--and da.Num_Proc in (select Num_Proc from #tmp_num_proc (nolock))            
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)       
        
        
set nocount off        
    
     
 */        
          
                  
                  
 /*                 
 create table #tmp_num_proc           
 (          
 numero_po varchar(16) COLLATE Latin1_General_CI_AI           
 ,num_proc varchar(16) COLLATE Latin1_General_CI_AI           
 )             
         
if 1 = 1         
begin        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201706002BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAATL201711049BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAATL201708047BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAFUN201708001BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAATL201706042BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201709010BR'        
 insert into #tmp_num_proc select  'xxxxxx','IANVS201706001BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201703059BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201602022BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703055BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703054BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703023BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201702009BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201702008BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201702007BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201608014BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201606045BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201603011BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201604001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602021BR'        
 insert into #tmp_num_proc select  'xxxxxx','EAOSR201712001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASYN201603001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EAOSR201611001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EAOSR201611002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201702001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201702002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201702003BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201709001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201712001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201710002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EASGB201710003BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201601007BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201603026BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMBCB201603006BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602006BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMAMZ201603008BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMBCB201605002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201602005BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMFMC201609001BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201610007BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201610023BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201612031BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201703018BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMBCB201703002BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201705034BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201706030BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201709004BR'        
 insert into #tmp_num_proc select  'xxxxxx','EMATL201710018BR'        
 insert into #tmp_num_proc select  'xxxxxx','IAAPB201801006BR '        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201712066BR'        
 insert into #tmp_num_proc select  'xxxxxx','IACSR201706024BR'        
        
end         
        
        
        
                  
                  
select          
numero_po as Numero_PO,           
        
        
        
replacE(replacE(replace(ltrim(rtrim((        
numero_po        
))),' ',''),'/','-'),'\','') as pasta,                 
 UPPER(nome_arquivo) nome_arquivo,                  
-- UPPER('PO_' + replacE(replacE(replace((        
--numero_po         
-- ),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ isnull(smart_doc,'') + '.pdf') as NOME_DOC,         
        
        
        
 UPPER(DA.Num_Proc+'_'+ isnull(smart_doc,'')) + '.pdf' as NOME_DOC,         
                           
 da.Id_DC                 
 from doc_anexos DA with(nolock)                
 inner Join Tipo_DoC_Cliente TC (nolock)         
 on TC.id_dc=da.Id_DC            
inner join #tmp_num_proc tmp        
 on da.Num_Proc          = tmp.num_proc           
 --inner join vwClienteALLJOBS a (nolock)         
 --on A.Num_Proc = DA.Num_Proc                  
 --inner join Pessoa P         
 --on P.cd_pes = A.cd_cliente                 
 --inner join tarefas_processos tp         
 --on da.Num_Proc =  tp.Num_Proc        
where         
--tp.id_Task=4        
--and tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000' and        
da.Id_DC in (15,20,44,74,149,177,178,180,181)         
--and da.Num_Proc in (select Num_Proc from #tmp_num_proc (nolock))        
        
        
  select * from tipo_tarefas  where id_task = 4       
        
        
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)        
  */     
        
        
/*        
select * from Tipo_DoC_Cliente        
        
002 - Invoice        
011 - Packing list        
020 - Doc. Embarque        
021 - Certificado de Seguro        
023 - Li number        
044 - BL original        
005 - DI number        
006 - CI number        
010 - Nota Fiscal        
013 - Certificado de Origem        
060 - Prestação de Contas        
075 - Guia de exoneração ICMS        
0143 - SDA        
*/        
        
        
/*     
        
        
        
    alter procedure [dbo].[spPDFKHDA_NEW2]               
              
AS              
              
              
              
select distinct dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),               
 UPPER(nome_arquivo) nome_arquivo,              
 UPPER('PO_' + replacE(replacE(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ smart_doc + '.pdf') as NOME_DOC,               
 --isnull(replace(replace(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,3),' ',''),'/',''),'SalesOrder_NotFound') pasta,              
 --isnull(replace(replace(po.Numero_PO,' ',''),'/',''),'PONotFound') pasta,              
 --replace(replace(isnull(dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1),'PONotFound'),' ',''),'/','')  pasta,              
 DMS_Code             
 from doc_anexos DA with(nolock)            
 inner Join Tipo_DoC_Cliente TC with(nolock) on TC.id_dc=da.Id_DC                    
 --join Fatura_CHB F on left(F.Fatura_PC,16) = DA.Num_Proc        
 join vwClienteALLJOBS a with(nolock) on A.Num_Proc = DA.Num_Proc              
 join Pessoa P on P.cd_pes = A.cd_cliente              
 inner join tarefas_processos tp on da.Num_Proc =  tp.Num_Proc    
where tp.id_Task=4    
and  tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000'    
and p.Apelido in     
(    
'GRUPO DUPONT'    
,'DOW AGROSCI - 1616C'    
,'DOW AGROSCI - 1617C'    
,'DOW - 3770C'    
)    
and da.Id_DC in (11,16,2,23,25,20,6,5,44,10)    
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)    
  
PL 011 COA 016 Invoice 002 LI 023 REQ MAPA 025 DOC de embarque 020 CI 006 DI 005 BL 044 NF 010    
*/    
    
    
/*  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
alter procedure [dbo].[spPDFKHDA_NEW2]               
              
AS              
SET NOCOUNT ON                  
 create table #tmp_num_proc       
 (      
 num_proc varchar(16) COLLATE Latin1_General_CI_AI       
 )         
      
              
select      
(select top 1 Numero_PO from vwPO_ALL (nolock) where num_proc = DA.Num_Proc order by ID_PO) as Numero_PO,       
replacE(replacE(replace(ltrim(rtrim((select top 1 Numero_PO from vwPO_ALL (nolock) where num_proc = DA.Num_Proc order by ID_PO))),' ',''),'/','-'),'\','') as pasta,             
 UPPER(nome_arquivo) nome_arquivo,              
 UPPER('PO_' + replacE(replacE(replace((select top 1 Numero_PO from vwPO_ALL (nolock) where num_proc = DA.Num_Proc order by ID_PO),' ',''),'/','-'),'\','') + '_' +DA.Num_Proc+'_'+ smart_doc + '.pdf') as NOME_DOC,                        
 DMS_Code             
 from doc_anexos DA with(nolock)            
 inner Join Tipo_DoC_Cliente TC (nolock)     
 on TC.id_dc=da.Id_DC                    
 --inner join vwClienteALLJOBS a (nolock)     
 --on A.Num_Proc = DA.Num_Proc              
 --inner join Pessoa P     
 --on P.cd_pes = A.cd_cliente              
 --inner join tarefas_processos tp     
 --on da.Num_Proc =  tp.Num_Proc    
where     
--tp.id_Task=4    
--and tp.dt_Conclusao between '2019-08-01 00:00:00.000' and '2019-08-31 00:00:00.000' and    
 da.Id_DC in (2,11,20,21,23,44,5,6,10,13,60,75,143)    
and da.Num_Proc in (select Num_Proc from #tmp_num_proc (nolock))    
    
ORDER BY dbo.fBusca_Docs_PO_Modal(DA.Num_Proc,1)    
    
    
    
/*    
select * from Tipo_DoC_Cliente    
    
002 - Invoice    
011 - Packing list    
020 - Doc. Embarque    
021 - Certificado de Seguro    
023 - Li number    
044 - BL original    
005 - DI number    
006 - CI number    
010 - Nota Fiscal    
013 - Certificado de Origem    
060 - Prestação de Contas    
075 - Guia de exoneração ICMS    
0143 - SDA    
*/  
     
        
        
*/
GO
