SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSmart_Levis_XML_Sel]
AS

	select num_proc, xml_doc, nome_arquivo,ISd_Number from Smart_Levis_XML S
		Join LLP_Imp_Mar LLP on S.Num_Proc = LLP.Num_Proc_Lim	
	where 
		dt_envio is null and isnull(id_status,0) <> 9
	
		
	union all
	
	select num_proc, xml_doc, nome_arquivo,ISd_Number from Smart_Levis_XML S
		Join LLP_Imp_AER LLP on S.Num_Proc = LLP.Num_Proc_Lia	
	where 
		dt_envio is null and isnull(id_status,0) <> 9		
		
	
	
	
	
--select * from po_him with(nolock)  
--where num_proc_him='IMLVS201410003BR' 
--and (id_dc=9)
--and numero_po_him <> 'Contract#:00000000' 
--order by id_dc desc

--select * from po_hia with(nolock)  
--where num_proc_hia='IALVS201409002BR' 
--and (id_dc=9)
--and numero_po_hia <> 'Contract#:00000000' 
--order by id_dc desc

--IALVS201409001BR - 3280012589
--IALVS201409002BR - 3280012626
--IMLVS201408001BR - BR-010203
--IMLVS201409001BR - 3289957752-05594
--IMLVS201410001BR - 4889910000
--IMLVS201410002BR - 3280013660
--IMLVS201410003BR - 49985900000



























GO
