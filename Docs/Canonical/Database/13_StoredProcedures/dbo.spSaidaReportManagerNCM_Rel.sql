SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--atlantis.dbo.spSaidaReportManagerNCM_Rel 'IMATL20100407701'

CREATE Procedure [dbo].[spSaidaReportManagerNCM_Rel]
	@Num_Proc	Varchar(16)

AS

select num_proc Job,'N/A' productid,'N/A' uom, 0 qty,NCM,null respoPO,null Business,null ValueCenter,getdate() PO_req,Descricao_NCM Produto_Descr,peso_bruto_him grossweight,peso_liquido_him netweight,'NA' Tipo_Ordem,null Planta_Exp, null Planta_Imp,null PO_GRP,'N/A' Busines_Group,'' ITO_Especialista from proc_ncm P with(nolock)
Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
Join House_imp_mar hou with(nolock) on hou.num_proc_him=num_proc
where
	num_proc=@Num_Proc

Union all

select num_proc Job,'N/A' productid,'N/A' uom, 0 qty,NCM,null respoPO,null Business,null ValueCenter,getdate() PO_req,Descricao_NCM Produto_Descr,peso_bruto_hio grossweight,peso_real_hio netweight,'NA' Tipo_Ordem,null Planta_Exp, null Planta_Imp,null PO_GRP,'N/A' Busines_Group,'' ITO_Especialista from proc_ncm P with(nolock)
Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
Join House_imp_out hou with(nolock) on hou.num_proc_hio=num_proc
where
	num_proc=@Num_Proc



union 


select num_proc Job,'N/A' productid,'N/A' uom, 0 qty,NCM,null respoPO,null Business,null ValueCenter,getdate() PO_req,Descricao_NCM Produto_Descr,peso_bruto_hia grossweight,peso_real_hia netweight,'NA' Tipo_Ordem,null Plant_Exp, null Planta_Imp,Null PO_GRP,'N/A' Busines_Group,'' ITO_Especialista  from proc_ncm P with(nolock)
Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
Join House_imp_aer hou with(nolock) on hou.num_proc_hia=num_proc
where
	num_proc=@Num_Proc


union 


select num_proc Job,'N/A' productid,'N/A' uom, 0 qty,NCM,null respoPO,null Business,null ValueCenter,getdate() PO_req,Descricao_NCM Produto_Descr,peso_bruto_hea grossweight,peso_real_hea netweight,'NA' Tipo_Ordem,null Plant_Exp, null Planta_Imp,null PO_GRP,'N/A' Busines_Group,'' ITO_Especialista  from proc_ncm P with(nolock)
Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
Join House_exp_aer hou with(nolock) on hou.num_proc_hea=num_proc
where
	num_proc=@Num_Proc


union 

select num_proc Job,'N/A' productid,'N/A' uom, 0 qty,NCM,null respoPO,null Business,null ValueCenter,getdate() PO_req,Descricao_NCM Produto_Descr,peso_bruto_hem grossweight,peso_liquido_hem netweight,'NA' Tipo_Ordem,null Plant_Exp, null Planta_Imp,null PO_GRP,'N/A' Busines_Group,'' ITO_Especialista  from proc_ncm P with(nolock)
Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
Join House_exp_mar hou with(nolock) on hou.num_proc_hem=num_proc
where
	num_proc=@Num_Proc


union 

select num_proc Job,'N/A' productid,'N/A' uom, 0 qty,NCM,null respoPO,null Business,null ValueCenter,getdate() PO_req,Descricao_NCM Produto_Descr,peso_bruto_heo grossweight,peso_real_heo netweight,'NA' Tipo_Ordem,null Plant_Exp, null Planta_Imp,null PO_GRP,'N/A' Busines_Group,'' ITO_Especialista  from proc_ncm P with(nolock)
Join NCM with(nolock) on NCM.id_ncm=P.ID_Ncm
Join House_exp_out hou with(nolock) on hou.num_proc_heo=num_proc
where
	num_proc=@Num_Proc






GO
