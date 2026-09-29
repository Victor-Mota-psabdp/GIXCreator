SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--060-Prestação de Contas
--005-DI Number
--090-Protocolo Entr. Transp.
--002-INVOICE
--013-Certificado de Origem
--081-Recibo de Armazenagem
--072-Recibo de frete e taxas
--011-Packing List
--044-BL - Original

--select * from Smart_Levis_XML where Num_Proc = 'IMLVS201410035BR'

CREATE procedure [dbo].[spSmart_Levis_Documents_Rel]--[dbo].[spSmart_Levis_Documents_Rel] 'ALL'
	@ALL as Varchar(3)
AS
	select distinct
		HOU.num_proc								[JOB],
		Numero_PO_HIM								[DI Number],	
		D60.Nome_Arquivo							[060-Prestação de Contas],
		D5.Nome_Arquivo								[005-DI Number],
		D90.Nome_Arquivo							[090-Protocolo Entr. Transp.],
		D2.Nome_Arquivo								[002-INVOICE],
		D13.Nome_Arquivo							[013-Certificado de Origem],
		D81.Nome_Arquivo							[081-Recibo de Armazenagem],
		D72.Nome_Arquivo							[072-Recibo de frete e taxas],
		D11.Nome_Arquivo							[011-Packing List],
		D44.Nome_Arquivo							[044-BL - Original]		
	--	HOU.dt_envio_doc							[Data de Envio para  Levis]
	from vwCliente  HOU	with(nolock)	
		Left Join LLP_Imp_Mar	LLP		with(nolock) on HOU.Num_Proc		=	LLP.Num_Proc_Lim
		Left join doc_anexos	D60 	with(nolock) on D60.num_proc		=	HOU.num_proc and D60.id_dc = 60
		Left join doc_anexos	D5		with(nolock) on D5.num_proc			=	HOU.num_proc and D5.id_dc = 5
		Left join doc_anexos	D90		with(nolock) on D90.num_proc		=	HOU.num_proc and D90.id_dc = 90
		Left join doc_anexos	D2		with(nolock) on D2.num_proc			=	HOU.num_proc and D2.id_dc = 2
		Left join doc_anexos	D13		with(nolock) on D13.num_proc		=	HOU.num_proc and D13.id_dc = 13
		Left join doc_anexos	D81		with(nolock) on D81.num_proc		=	HOU.num_proc and D81.id_dc = 81
		Left join Doc_Anexos	D72		with(nolock) on D72.Num_Proc		=	HOU.num_proc and D72.Id_DC = 72
		Left join Doc_Anexos	D11		with(nolock) on D11.Num_Proc		=	HOU.num_proc and D11.Id_DC = 11
		Left join Doc_Anexos	D44		with(nolock) on D44.Num_Proc		=	HOU.num_proc and D44.Id_DC = 44
		Left Join PO_HIM		DI		with(nolock) on DI.Num_Proc_him		=	LLP.Num_Proc_Lim  and DI.id_dc = 5		
	where
		--LEN(HOU.ISD_Number) = 10 and ISNUMERIC(HOU.ISD_Number) = 1
		--and ISNULL(llp.ID_Status,0) <> 9				
		SUBSTRING(hou.num_proc,3,3)='LVS'
UNION ALL

	select distinct
		HOU.num_proc								[JOB],
		
		Numero_PO_HIM								[DI Number],
		D60.Nome_Arquivo							[060-Prestação de Contas],
		D5.Nome_Arquivo								[005-DI Number],
		D90.Nome_Arquivo							[090-Protocolo Entr. Transp.],
		D2.Nome_Arquivo								[002-INVOICE],
		D13.Nome_Arquivo							[013-Certificado de Origem],
		D81.Nome_Arquivo							[081-Recibo de Armazenagem],
		D72.Nome_Arquivo							[072-Recibo de frete e taxas],
		D11.Nome_Arquivo							[011-Packing List],
		D44.Nome_Arquivo							[044-BL - Original]
	--	HOU.dt_envio_doc							[Data de Envio para  Levis]
	from vwcliente HOU	with(nolock)	
		Left Join LLP_Imp_aer	LLP		with(nolock) on HOU.Num_Proc		=	LLP.Num_Proc_Lia
		Left join doc_anexos	D60 	with(nolock) on D60.num_proc		=	HOU.Num_Proc and D60.id_dc = 60
		Left join doc_anexos	D5		with(nolock) on D5.num_proc			=	HOU.Num_Proc and D5.id_dc = 5
		Left join doc_anexos	D90		with(nolock) on D90.num_proc		=	HOU.Num_Proc and D90.id_dc = 90
		Left join doc_anexos	D2		with(nolock) on D2.num_proc			=	HOU.Num_Proc and D2.id_dc = 2
		Left join doc_anexos	D13		with(nolock) on D13.num_proc		=	HOU.Num_Proc and D13.id_dc = 13
		Left join doc_anexos	D81		with(nolock) on D81.num_proc		=	HOU.Num_Proc and D81.id_dc = 81
		Left join Doc_Anexos	D72		with(nolock) on D72.Num_Proc		=	HOU.Num_Proc and D72.Id_DC = 72
		Left join Doc_Anexos	D11		with(nolock) on D11.Num_Proc		=	HOU.Num_Proc and D11.Id_DC = 11
		Left join Doc_Anexos	D44		with(nolock) on D44.Num_Proc		=	HOU.Num_Proc and D44.Id_DC = 44			
		Left Join PO_HIM		DI		with(nolock) on DI.Num_Proc_him		=	LLP.Num_Proc_Lia  and DI.id_dc = 5		

	where
		SUBSTRING(hou.num_proc,3,3)='LVS'
GO
