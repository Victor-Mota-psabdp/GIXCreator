SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTaxasBDPInvoice_BO_Sel]--'BOCSR201604003BR'
(
	@Processo varchar(16)
)
AS

SET NOCOUNT ON
	
	
	Declare @TempTaxas Table
	(
		[Status]		varchar(10),
		Invoiced	varchar(1),
		Num_Proc	varchar(16),
		Nome_tp_tx	varchar(50),
		DC			varchar(1),
		Moeda		varchar(50),
		Valor		decimal(10,2),
		Paridade	float,
		Valor_Total	decimal(10,2),				
		NF			varchar(12),
		[Site]		varchar(1),
		Repasse_TX	varchar(1),
		Emissao		Datetime,
		vlr_pg		decimal(10,2),
		Ref			varchar(50)
	)
		

	Insert @TempTaxas
		SELECT
			'New',
			'X', 
			CC.Num_proc_hia,
			TT.Nome_tp_tx,
			cc.DC_HIA,
			TM.Nome_Tp_Moeda,
			CC.Vlr_Org_HIA, 
			
			(case When
					CC.Num_NF_HIA is not NULL
				Then 							
					FARG.Paridade
				else
			(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
				else 
			(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
				else 
			(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
				else 
			(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
			else
				dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
			end)end)end)end)end)Paridade,	
			
			(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') * Vlr_Org_HIA 
				else 
			(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') * Vlr_Org_HIA 
				else 
			(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') * Vlr_Org_HIA 
				else 
			(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' 
				then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA') * Vlr_Org_HIA 				
			else
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')  * Vlr_Org_HIA 
			end)end)end)end),
			CC.Num_NF_HIA NF, 
			CC.Ref_Acesso_NF_HIA [Site],
			Repasse_TX,
			isnull(FARG.Dt_Fatura,GETDATE()) Emissao,
			isnull(CXA.Vlr_Pgto_Rcto_HIA,S.Vlr_Pgto_Rcto),
			ISNULL(CXA.Num_Lcto,S.ID)
		FROM 
			vwcta_Cte CC with (nolock)
			left Join Tipo_Taxa TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
			left Join Tipo_Moeda TM with (nolock)on CC.Cd_Tp_Moeda = TM.Cd_Tp_Moeda					
			Left join vwCXAS CXA with (nolock)on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
			--Join Pessoa_ATL_AX P with (nolock)on P.cd_pes=HOU.cd_cliente and Tipo='C'
			Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc    
			Left Join vwFaturasValidasCHB ITT with (nolock) on itt.Num_Proc=CC.Num_Proc_HIA and itt.cd_tp_Tx=CC.cd_tp_Tx and itt.dc=CC.DC_HIA
			Left join vwAXDocs AX with (nolock)on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc				
			Left join vwSolPgtoCtaCteAprovadas S with (nolock)on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc					
			left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
		WHERE
			--cc.DC_HIA = 'D' and
			CC.Num_Proc_HIA = @Processo
			and Fat.num_proc is null
			and ITT.num_proc is null
			and Desp_Org_HIA='N' 
			and desat_tx='N'
			--and id_ax is null
			--and S.ID is null			
		
	
update 
	T  
set 
	T.Paridade=T1.Paridade
from 
	@TempTaxas as T
JOIN
	@TempTaxas  as T1
	on T.Moeda = T1.Moeda and T1.NF is not NULL

	
--select * from @TempTaxas where month(Emissao) = MONTH(getdate()) 
select [Status],Invoiced,Num_Proc,Nome_tp_tx,dc
,Moeda,Valor,Paridade,Valor_Total ,NF,[Site],
Repasse_TX,Emissao,vlr_pg,Ref from @TempTaxas where month(Emissao) = MONTH(getdate()) 




GO
