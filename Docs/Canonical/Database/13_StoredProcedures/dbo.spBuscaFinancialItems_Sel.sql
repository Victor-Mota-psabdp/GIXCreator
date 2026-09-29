SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBuscaFinancialItems_Sel]-- spBuscaFinancialItems_Sel 'EX'
@Modal Varchar(2)

AS
		SET NOCOUNT ON
	--Alterdo Por Erbson 18/02/2016 - Excluir da tabela exchange as taxa que não devem ser enviados para o AX (000.1)	
	delete exchange_Cta_CTe
	where ID in (						
	select  E.ID from exchange_Cta_CTe E with(nolock)
	join vwcta_Cte C with(nolock) on E.Num_Proc = C.Num_Proc_HIA and E.IC = C.IC
	join  Tipo_Taxa ChargeList with(nolock) on C.Cd_Tp_Tx = ChargeList.Cd_Tp_Tx
	Join Tipo_Taxa_AX ChargeListAXPL with(nolock) on ChargeListAXPL.Cd_Charge_AX = ChargeList.CD_AX_Resultado 
	Join Tipo_Taxa_AX ChargeListAXPT with(nolock) on ChargeListAXPT.Cd_Charge_AX = ChargeList.Cd_AX_Repasse 
	where  (ChargeList.CD_AX_Resultado = '000.1' or ChargeList.Cd_AX_Repasse  = '000.1') and E.dt_envio is null)
	
	--update E set Dt_Envio = '1983-05-15' from  Exchange_Cta_Cte E	
	--left join vwcta_Cte C on E.Num_Proc = C.Num_Proc_HIA and C.IC = E.IC
	--where Tipo_Oper in ('U','I') and C.Num_Proc_HIA is null and Dt_Envio is null
		
		
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_SENT IA on IA.ID=E.ID
			Where
				E.dt_envio is null 


	select top 200 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
	Where Tipo_Oper = 'I'and E.dt_envio is null
	AND J.SFDCID is not null 
	--and F.SFDCID is null 
	Union aLl
	
	
	select top 200 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
	Where Tipo_Oper = 'U' and F.SFDCID is not null and E.dt_envio is null
	AND J.SFDCID is not null 
	
	Union ALL

	select top 200 E.Num_Proc,E.IC,e.id IDExc,NULL JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	join vwCliente C with(nolock) on E.num_proc=C.Master
	Join dbo.Job_SFDC J with(nolock) on C.num_proc=J.num_proc 
	Where 
	--E.Num_Proc = 'EAGRU201601011' and e.IC = '30342' and
	Tipo_Oper = 'I'and E.dt_envio is null
	AND J.SFDCID is not null 
	group by E.Num_Proc,E.IC,e.id 	
	
	Union all
	
	select top 200 E.Num_Proc,E.IC,e.id IDExc,NULL JobSFDCID from exchange_Cta_CTe E with(nolock)
	Left Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	join vwCliente C with(nolock) on E.num_proc=C.Master
	Join dbo.Job_SFDC J with(nolock) on C.num_proc=J.num_proc 
	Where 
	--E.Num_Proc = 'EAGRU201601011' and e.IC = '30342' and
	Tipo_Oper = 'U'and  F.SFDCID is not null and E.dt_envio is null
	AND J.SFDCID is not null 
	group by E.Num_Proc,E.IC,e.id order by 	e.id
option(hash join)
/*
if @Modal not in ('IA' ,'IO','IM','II','IF','MM','RR','EM','OX','EX','EC'   )

Begin

	select E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
	Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
	Where Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null
	and LEFT(e.num_proc,2)=@Modal and  J.Num_PRoc is not null and LEFT(e.num_proc,2) not in  ('IA','IO')
		AND J.SFDCID is not null 

	Union All

	select E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
	Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
	Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
	Where Tipo_Oper<> 'I' and F.SFDCID is NOT null and E.dt_envio is null
	and LEFT(e.num_proc,2)=@Modal  and  J.Num_PRoc is not null and E.Dt_Retorno is null 
		AND J.SFDCID is not null 

END
if @Modal='MM'
	begin
	
	select E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
	Join vwCliente CC on CC.Master = E.Num_Proc 
	 Join Financial_SFDC F with(nolock) on F.num_proc=CC.num_proc and F.IC=E.IC
	left Join dbo.Job_SFDC J with(nolock) on CC.num_proc=J.num_proc 
	Where Tipo_Oper= 'I' and E.dt_envio is null
	and     J.Num_PRoc is not null and E.Dt_Retorno is null 
		AND J.SFDCID is not null and F.SFDCID is null
		order by 1
	
	End

if @Modal = 'IA'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_IA IA on IA.ID=E.ID
			Where
				E.dt_envio is null 
	
		select E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null
		and LEFT(e.num_proc,2)=@Modal and  J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'IA'
		and E.Dt_Retorno is null 
				AND J.SFDCID is not null 


	End
	
if @Modal = 'IO'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_IO I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null
		and LEFT(e.num_proc,2)=@Modal and  J.Num_PRoc is not null and E.Dt_Retorno is null 
		AND J.SFDCID is not null 

	End
	
	if @Modal = 'IM'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_IM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and LEFT(e.num_proc,2)=@Modal and  J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'IM'
				AND J.SFDCID is not null 
		and substring(E.Num_Proc,3,3) not in ('CSR','FMC','ROB','OXT')
		order by 1 
	End
	
	if @Modal = 'II'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_IM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and   J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'IM'
				AND J.SFDCID is not null 
		and E.Num_Proc  like 'IMCSR%'
		order by 1 

	End
if @Modal = 'OX'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_IM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and   J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'IM'
				AND J.SFDCID is not null 
		and E.Num_Proc  like 'IMOXT%'
		order by 1 

	End
	
	if @Modal = 'RR'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_IM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and   J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'IM'
				AND J.SFDCID is not null 
		and E.Num_Proc  like 'IMROB%'
		order by 1 

	End
	
	if @Modal = 'IF'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_IM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and   J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'IM'
				AND J.SFDCID is not null 
		and substring(E.Num_Proc,3,3)='FMC' --  like 'IMCSR%'
		order by 1 
	End
	
if @Modal = 'EM'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_EM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and LEFT(e.num_proc,2)=@Modal and  J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'EM'
				AND J.SFDCID is not null 
		and SUBSTRING(J.Num_Proc,3,3) not in ('OXT','CSR')

	End
	
	if @Modal = 'EX'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_EM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and  J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'EM'
				AND J.SFDCID is not null 
and SUBSTRING(J.Num_Proc,3,3)  in ('OXT')

	End
	
		if @Modal = 'EC'
	Begin
		SET NOCOUNT ON
		Update
			Exchange_Cta_Cte 
				Set Dt_Envio = GETDATE()
			From
				Exchange_Cta_Cte E
				Join Exchange_Cta_Cte_EM I on I.ID=E.ID
			Where
				E.dt_envio is null 
	
		select top 100000 E.Num_Proc,E.IC,e.id IDExc,J.SFDCID JobSFDCID from exchange_Cta_CTe E with(nolock)
		Join Financial_SFDC F with(nolock) on F.num_proc=E.num_proc and F.IC=E.IC
		Join dbo.Job_SFDC J with(nolock) on E.num_proc=J.num_proc 
--		Left Join Exchange_cta_Cte_IA IA on IA.ID=E.ID
		Where E.Tipo_Oper='I'  and F.SFDCID is null and E.dt_envio is null and E.Dt_Retorno is null 
		and  J.Num_PRoc is not null and LEFT(e.num_proc,2) = 'EM'
				AND J.SFDCID is not null 
and SUBSTRING(J.Num_Proc,3,3)  in ('CSR')

	End
	
	
	*/
GO
