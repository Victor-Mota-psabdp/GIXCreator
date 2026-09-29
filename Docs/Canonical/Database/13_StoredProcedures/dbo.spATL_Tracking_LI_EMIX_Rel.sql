SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select 'LI Date' [Tipo] union all select 'Def. LI - Date' 
CREATE Procedure [dbo].[spATL_Tracking_LI_EMIX_Rel]--'2015-07-01','Def. LI - Date' 

	@DtInicial datetime,
	@Tipo varchar(30)
	
As

select 
	'Ocean' [Modal],
	LLP.Num_Proc_LIM							[BDP Ref.],
	CSN.Apelido									[Consignee],
	DST.Nome_Local								[Destination],
	(case when CC.Campo_Dados = 1 then	
		'SIM'
	else 
		(case when CC.Campo_Dados = 2 then	
		'NÂO'
		else
		'' end)end)								[Necessidade de LI?],
	CONVERT(varchar(10),Sl.Dt_Solicitacao,103)	[LI Request - Date],
	SL.Num_Solicitacao							[ID],
	SL.Num_LI									[Import License],
	CONVERT(varchar(10),SL.Dt_LI,103)			[LI Date],
	CONVERT(varchar(10),SL.Dt_Deferimento,103)	[Def. LI - Date],
	(case when D.Nome_Arquivo is not null then	'YES' else 'NO' end) [PDF - LI],
	CONVERT(varchar(10),SL.Dt_Aut_Embarque,103)	[Green light - Date],	
	(RIGHT('000'+CAST(TSL.ID_Status_LI as varchar(2)),2) + ' - ' + TSL.Status_LI_Descricao)	[Process Status],
	
	ID_Empresa.Campo_Dados  [ID Empresa],
	ID_CNPJ.Campo_Dados		[ID_CNPJ]
	
from Solicitacao_LI		SL with(nolock)
	join Tipo_LI		TL with(nolock) on TL.ID_Tipo = SL.ID_Tipo_LI
	join Usuario		US with(nolock) on SL.Cd_Usuario_Req = US.Cd_Usuario
	join Tipo_Status_LI TSL with(nolock) on SL.ID_Status = TSL.ID_Status_LI
	Join LLP_Imp_Mar	LLP with(nolock) on LLP.num_proc_LIm=SL.Num_Proc
	Join House_Imp_Mar	HOU with(nolock) on LLP.num_proc_LIm=HOU.Num_Proc_HIM		
	join Pessoa			CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIM
	left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
	left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13	
	Join Localidade		DST with(nolock) on HOU.cd_dst_HIM=DST.cd_local	
	left join Doc_Anexos D with(nolock) on D.Num_Proc = SL.Num_Solicitacao and Id_DC = 23
	left join Campo_Processo CC with(nolock) on CC.num_proc = SL.Num_Proc and CC.id_campo = 5
where
	((@Tipo = 'LI Date' and  SL.Dt_LI >= @DtInicial) or
	(@Tipo = 'Def. LI - Date' and  SL.Dt_Deferimento >= @DtInicial)) 
	
	
union all

	select 
	'AIR' Modal,
	LLP.Num_Proc_LIA							[BDP Ref.],
	CSN.Apelido									[Consignee],
	DST.Nome_Local								[Destination],
	(case when CC.Campo_Dados = 1 then	
		'SIM'
	else 
		(case when CC.Campo_Dados = 2 then	
		'NÂO'
		else
		'' end)end)								[Necessidade de LI?],
	CONVERT(varchar(10),Sl.Dt_Solicitacao,103)	[LI Request - Date],
	SL.Num_Solicitacao							[ID],
	SL.Num_LI									[Import License],
	CONVERT(varchar(10),SL.Dt_LI,103)			[LI Date],
	CONVERT(varchar(10),SL.Dt_Deferimento,103)	[Def. LI - Date],
	(case when D.Nome_Arquivo is not null then	'YES' else 'NO' end) [PDF - LI],
	CONVERT(varchar(10),SL.Dt_Aut_Embarque,103)	[Green light - Date],	
	(RIGHT('000'+CAST(TSL.ID_Status_LI as varchar(2)),2) + ' - ' + TSL.Status_LI_Descricao)	[Process Status],
	
	ID_Empresa.Campo_Dados  [ID Empresa],
	ID_CNPJ.Campo_Dados		[ID_CNPJ]
	
from Solicitacao_LI		SL with(nolock)
	join Tipo_LI		TL with(nolock) on TL.ID_Tipo = SL.ID_Tipo_LI
	join Usuario		US with(nolock) on SL.Cd_Usuario_Req = US.Cd_Usuario
	join Tipo_Status_LI TSL with(nolock) on SL.ID_Status = TSL.ID_Status_LI
	Join LLP_Imp_Aer	LLP with(nolock) on LLP.Num_Proc_Lia=SL.Num_Proc
	Join House_Imp_Aer	HOU with(nolock) on LLP.num_proc_LIa=HOU.Num_Proc_HIa		
	join Pessoa			CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIA
	left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
	left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13		
	Join Localidade		DST with(nolock) on HOU.cd_dst_HIA=DST.cd_local	
	left join Doc_Anexos D with(nolock) on D.Num_Proc = SL.Num_Solicitacao and Id_DC = 23
	left join Campo_Processo CC with(nolock) on CC.num_proc = SL.Num_Proc and CC.id_campo = 5
where 
	((@Tipo = 'LI Date' and  SL.Dt_LI >= @DtInicial) or
	(@Tipo = 'Def. LI - Date' and  SL.Dt_Deferimento >= @DtInicial))  
	
UNION ALL

	select 
	'Others'									Modal,
	LLP.Num_Proc_LIO							[BDP Ref.],
	CSN.Apelido									[Consignee],
	DST.Nome_Local								[Destination],
	(case when CC.Campo_Dados = 1 then	
		'SIM'
	else 
		(case when CC.Campo_Dados = 2 then	
		'NÂO'
		else
		'' end)end)								[Necessidade de LI?],
	CONVERT(varchar(10),Sl.Dt_Solicitacao,103)	[LI Request - Date],
	SL.Num_Solicitacao							[ID],
	SL.Num_LI									[Import License],
	CONVERT(varchar(10),SL.Dt_LI,103)			[LI Date],
	CONVERT(varchar(10),SL.Dt_Deferimento,103)	[Def. LI - Date],
	(case when D.Nome_Arquivo is not null then	'YES' else 'NO' end) [PDF - LI],
	CONVERT(varchar(10),SL.Dt_Aut_Embarque,103)	[Green light - Date],	
	(RIGHT('000'+CAST(TSL.ID_Status_LI as varchar(2)),2) + ' - ' + TSL.Status_LI_Descricao)	[Process Status],
	
	ID_Empresa.Campo_Dados  [ID Empresa],
	ID_CNPJ.Campo_Dados		[ID_CNPJ]
	
from Solicitacao_LI		SL with(nolock)
	join Tipo_LI		TL with(nolock) on TL.ID_Tipo = SL.ID_Tipo_LI
	join Usuario		US with(nolock) on SL.Cd_Usuario_Req = US.Cd_Usuario
	join Tipo_Status_LI TSL with(nolock) on SL.ID_Status = TSL.ID_Status_LI
	Join LLP_Imp_Out	LLP with(nolock) on LLP.Num_Proc_LiO=SL.Num_Proc
	Join House_Imp_Out	HOU with(nolock) on LLP.num_proc_LIO=HOU.Num_Proc_HIO		
	join Pessoa			CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIO
	left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
	left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13		
	Join Localidade		DST with(nolock) on HOU.cd_dst_HIO=DST.cd_local	
	left join Doc_Anexos D with(nolock) on D.Num_Proc = SL.Num_Solicitacao and Id_DC = 23
	left join Campo_Processo CC with(nolock) on CC.num_proc = SL.Num_Proc and CC.id_campo = 5
where 
	((@Tipo = 'LI Date' and  SL.Dt_LI >= @DtInicial) or
	(@Tipo = 'Def. LI - Date' and  SL.Dt_Deferimento >= @DtInicial)) 

	
order by [BDP Ref.],[LI Date]

OPTION(HASH JOIN)




GO
