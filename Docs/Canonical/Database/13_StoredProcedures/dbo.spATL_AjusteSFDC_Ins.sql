SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_AjusteSFDC_Ins]

as


--Envia CTACTE que não entram via Trigger
insert Exchange_Cta_Cte
select C.Num_Proc_HIA,C.IC,'I',GETDATE(),NULL,NULL from  vwCta_Cte C with(nolock)
join Tipo_Taxa TT with(nolock) on C.Cd_Tp_Tx = TT.Cd_Tp_Tx and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1') 
left join Exchange_Cta_Cte E with(nolock) on C.IC = E.IC and C.Num_Proc_HIA = E.Num_Proc
where E.IC is null and CONVERT(datetime, C.Dt_Ins_HIA,105) >='2016-01-01' 

union all

select C.Num_Proc_HIA,C.IC,'I',GETDATE(),NULL,NULL from  vwCta_Cte C with(nolock)
join Tipo_Taxa TT with(nolock) on C.Cd_Tp_Tx = TT.Cd_Tp_Tx and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1') 
left join Exchange_Cta_Cte E with(nolock) on C.IC = E.IC and C.Num_Proc_HIA = E.Num_Proc
left join vwCXAS CX with(nolock) on C.Num_Proc_HIA = Cx.Num_Proc_HIA and C.DC_HIA = CX.DC_HIA and C.Cd_Tp_Tx = CX.Cd_Tp_Tx
where E.IC is null and year(CONVERT(datetime, C.Dt_Ins_HIA,105)) > '2008'  and CX.Num_Lcto is null and Desp_Org_HIA = 'N' and substring(C.Num_Proc_HIA,3,3) not in ('REM','JOB')

option(hash join)

update E  set E.dt_retorno = Ex.dt_retorno  from Exchange_Cta_Cte E with(nolock)
join Exchange_Cta_Cte Ex with(nolock) on E.Num_Proc = Ex.Num_Proc and E.IC = Ex.IC  and EX.dt_retorno is not null and EX.ID>E.ID --and E.Tipo_Oper = Ex.Tipo_Oper
where   E.dt_retorno is null

insert Exchange_Cta_Cte
select distinct Num_proc,IC,Tipo_Oper,getdate(),NULL,NULL from Exchange_Cta_Cte with(nolock)
where Dt_Ins > GETDATE()-1 and  Dt_Envio <= GETDATE()-1 and dt_retorno is null and Dt_Envio > = '2014-01-01'

declare @TempSF Table
(
	Num_Proc varchar(16),
	IC bigint ,
	IDExc bigint,
	SFDCID varchar(50),
	Cd_Pes varchar(50),
	Cd_AX varchar(50),
	Tipo varchar(1),
	LOG varchar(max) 
) 

insert 	@TempSF (Num_Proc,IC,IDExc,SFDCID)
	select E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
	Where Tipo_Oper = 'I'and E.dt_envio is null
	AND J.SFDCID is not null 
	--and F.SFDCID is null 
	Union aLl
	
	
	select E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
	Where Tipo_Oper = 'U' and F.SFDCID is not null and E.dt_envio is null
	AND J.SFDCID is not null 
	
	Union ALL

	select E.Num_Proc,E.IC,e.id IDExc,NULL JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	join vwCliente C with(nolock) on E.num_proc=C.Master
	Join dbo.Job_SFDC J with(nolock) on C.num_proc=J.num_proc 
	Where 
	Tipo_Oper = 'I'and E.dt_envio is null
	AND J.SFDCID is not null 
	group by E.Num_Proc,E.IC,e.id 	
	
	Union all
	
	select E.Num_Proc,E.IC,e.id IDExc,NULL JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	join vwCliente C with(nolock) on E.num_proc=C.Master
	Join dbo.Job_SFDC J with(nolock) on C.num_proc=J.num_proc 
	Where 
	Tipo_Oper = 'U'and  F.SFDCID is not null and E.dt_envio is null
	AND J.SFDCID is not null 
	group by E.Num_Proc,E.IC,e.id order by 	e.id
	
	update S set S.Cd_Pes = C.Cd_Cred_Dev_HIA, LOG = 'Falta cadastro na tabela Pessoa_ATL_AX'  from @TempSF S
	join vwCta_cte C on S.Num_Proc = C.Num_Proc_HIA and S.IC = C.IC
	left join Pessoa_ATL_AX P on C.Cd_Cred_Dev_HIA = P.Cd_Pes
	where P.cd_ax is null and LOG is NULL

	update S set  S.Cd_Pes = C.Cd_Cred_Dev_HIA, S.Cd_AX = P.cd_ax, S.Tipo = P.Tipo ,  LOG = 'Falta cadastro na tabela Account_SFDC'  from @TempSF S
	join vwCta_cte C with(nolock) on S.Num_Proc = C.Num_Proc_HIA and S.IC = C.IC
	join Pessoa_ATL_AX P with(nolock) on C.Cd_Cred_Dev_HIA = P.Cd_Pes
	left join Account_SFDC A with(nolock) on P.cd_ax = A.Cd_AX  and P.Cd_Pes = A.cd_Pes and P.Tipo = A.Tipo 
	where  
	A.Cd_Pes is null and LOG is NULL

insert Account_SFDC
select  Cd_Pes,Cd_AX,Tipo,NULL,GETDATE(),NULL,NULL from @TempSF
where LOG = 'Falta cadastro na tabela Account_SFDC' group by Cd_Pes,Cd_AX,Tipo

update Account_SFDC set Dt_Envio = null
where SFDCID is null and Dt_Envio <= GETDATE()-5

update Job_SFDC set Dt_Envio = null
where dt_envio <= GETDATE()-5 and SFDCID is null
GO
