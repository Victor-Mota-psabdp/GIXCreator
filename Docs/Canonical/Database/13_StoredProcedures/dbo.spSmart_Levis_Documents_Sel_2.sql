SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tipo_Doc_Cliente
--060-Prestação de Contas
--005-DI Number
--090-Protocolo Entr. Transp.
--002-INVOICE
--013-Certificado de Origem - Não Obrigatorio
--081-Recibo de Armazenagem
--072-Recibo de frete e taxas
--011-Packing List
--044-BL - Original

--select * from doc_anexos where Num_Proc = 'IMLVS201410063BR' and id_dc in (2,44)
--IMLVS201410049BR_044.pdf
--IMLVS201410063BR

CREATE  procedure [dbo].[spSmart_Levis_Documents_Sel_2]
	
AS

	Declare @Enviadas Table
		(
			Num_proc	varchar(16)	
		)
	Begin 		
		Insert @Enviadas	
		Select distinct Num_Proc from [Smart_Levis_XML] 		
		where
			--Num_Proc = 'IMLVS201501007BR' and
			dt_envio_doc is not null
	End	

	select distinct   
		HOU.num_proc_him								[JOB],
		NULL										[JOB_Master],	
		'60;5;90;2;81;72;11;44'						[Doc_Anexos],
		'13'										[Doc_Anexos_Nao_Obrigatorios],
		Null										[Doc_Anexos_Master],
		'BR_' + REPLACE(Replace(DI.NUMERO_PO_HIM,'-',''),'/','') +
			'_' + replace(CONVERT(VARCHAR(10), GETDATE(), 101),'/','')		[DI]	
	from House_Imp_Mar  HOU	with(nolock)	
		Left Join LLP_Imp_Mar	LLP		with(nolock) on HOU.Num_Proc_him		=	LLP.Num_Proc_Lim
		 left join doc_anexos			D60 	with(nolock) on D60.num_proc		=	LLP.Num_Proc_Lim and D60.id_dc = 60
		join doc_anexos			D5		with(nolock) on D5.num_proc			=	LLP.Num_Proc_Lim and D5.id_dc = 5
		 left join doc_anexos			D90		with(nolock) on D90.num_proc		=	LLP.Num_Proc_Lim and D90.id_dc = 90
		 left join doc_anexos			D2		with(nolock) on D2.num_proc			=	LLP.Num_Proc_Lim and D2.id_dc = 2
		left join doc_anexos	D13		with(nolock) on D13.num_proc		=	LLP.Num_Proc_Lim and D13.id_dc = 13
		left join doc_anexos			D81		with(nolock) on D81.num_proc		=	LLP.Num_Proc_Lim and D81.id_dc = 81
		left join Doc_Anexos			D72		with(nolock) on D72.Num_Proc		=	LLP.Num_Proc_Lim and D72.Id_DC = 72
		left join Doc_Anexos			D11		with(nolock) on D11.Num_Proc		=	LLP.Num_Proc_Lim and D11.Id_DC = 11
		 left join Doc_Anexos			D44		with(nolock) on D44.Num_Proc		=	LLP.Num_Proc_Lim and D44.Id_DC = 44
		Left Join PO_HIM		DI		with(nolock) on DI.Num_Proc_him		=	LLP.Num_Proc_Lim  and DI.id_dc = 5		
		left join Levis_DOC EN	on En.Num_proc = Hou.Num_Proc_him
	where
		EN.Num_Proc is null
		--hou.Num_Proc  = 'IMLVS201410063BR' and
		--LEN(HOU.ISD_Number) = 10 and ISNUMERIC(HOU.ISD_Number) = 1
		--and ISNULL(llp.ID_Status,0) <> 9
		--and HOU.dt_envio_doc is null
		--and En.Num_proc is null	
		and hou.Num_Proc_HIM
		in
		(
		'IMLVS201411011BR',
'IALVS201411008BR',
'IALVS201411014BR',
'IALVS201411005BR',
'IALVS201411011BR',
'IALVS201411003BR',
'IALVS201411010BR',
'IALVS201411002BR',
'IALVS201411006BR',
'IALVS201411004BR',
'IALVS201411020BR',
'IALVS201410001BR',
'IALVS201410002BR',
'IALVS201411019BR',
'IALVS201501004BR',
'IALVS201411017BR',
'IALVS201411018BR',
'IALVS201411013BR',
'IALVS201411012BR',
'IALVS201411021BR',
'IALVS201501002BR',
'IALVS201501008BR',
'IALVS201501003BR',
'IALVS201412001BR',
'IALVS201412003BR',
'IMLVS201501020BR',
'IALVS201502001BR',
'IALVS201501007BR',
'IALVS201501006BR',
'IALVS201411007BR',
'IMLVS201412060BR',
'IALVS201503001BR',
'IMLVS201502062BR'

		)

		union all
		
		select distinct   
		HOU.num_proc_hia								[JOB],
		NULL										[JOB_Master],	
		'60;5;90;2;81;72;11;44'						[Doc_Anexos],
		'13'										[Doc_Anexos_Nao_Obrigatorios],
		Null										[Doc_Anexos_Master],
		'BR_' + REPLACE(Replace(DI.NUMERO_PO_hia,'-',''),'/','') +
			'_' + replace(CONVERT(VARCHAR(10), GETDATE(), 101),'/','')		[DI]	
	from House_Imp_aer  HOU	with(nolock)	
		Left Join LLP_Imp_aer	LLP		with(nolock) on HOU.Num_Proc_hia		=	LLP.Num_Proc_lia
		 left join doc_anexos			D60 	with(nolock) on D60.num_proc		=	LLP.Num_Proc_lia and D60.id_dc = 60
		join doc_anexos			D5		with(nolock) on D5.num_proc			=	LLP.Num_Proc_lia and D5.id_dc = 5
		 left join doc_anexos			D90		with(nolock) on D90.num_proc		=	LLP.Num_Proc_lia and D90.id_dc = 90
		 left join doc_anexos			D2		with(nolock) on D2.num_proc			=	LLP.Num_Proc_lia and D2.id_dc = 2
		left join doc_anexos	D13		with(nolock) on D13.num_proc		=	LLP.Num_Proc_lia and D13.id_dc = 13
		left join doc_anexos			D81		with(nolock) on D81.num_proc		=	LLP.Num_Proc_lia and D81.id_dc = 81
		left join Doc_Anexos			D72		with(nolock) on D72.Num_Proc		=	LLP.Num_Proc_lia and D72.Id_DC = 72
		left join Doc_Anexos			D11		with(nolock) on D11.Num_Proc		=	LLP.Num_Proc_lia and D11.Id_DC = 11
		 left join Doc_Anexos			D44		with(nolock) on D44.Num_Proc		=	LLP.Num_Proc_lia and D44.Id_DC = 44
		Left Join PO_hia		DI		with(nolock) on DI.Num_Proc_hia		=	LLP.Num_Proc_lia  and DI.id_dc = 5		
		left join Levis_DOC EN	on En.Num_proc = Hou.Num_Proc_hia
	where
		EN.Num_Proc is null
		--hou.Num_Proc  = 'IMLVS201410063BR' and
		--LEN(HOU.ISD_Number) = 10 and ISNUMERIC(HOU.ISD_Number) = 1
		--and ISNULL(llp.ID_Status,0) <> 9
		--and HOU.dt_envio_doc is null
		--and En.Num_proc is null	
		and hou.Num_Proc_hia
		in
		(
		'IALVS201411008BR',
'IALVS201411017BR',
'IALVS201501002BR',
'IALVS201501008BR',
'IALVS201501003BR',
'IALVS201412003BR',
'IMLVS201501020BR',
'IALVS201502001BR',
'IALVS201501007BR',
'IALVS201501006BR',
'IALVS201503001BR',
'IMLVS201502062BR'

		)

	
		
		
GO
