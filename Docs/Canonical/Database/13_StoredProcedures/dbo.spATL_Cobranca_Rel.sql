SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--spATL_Cobranca_Rel '','Grupo Exxon','2011-01-01','2012-01-10'
--spCobranca_Rel '','FMC','2011-11-01','2011-11-15'


CREATE procedure [dbo].[spATL_Cobranca_Rel]--'','%Exxon%','01-01-2000','12-19-2011'
(
	@Cliente as varchar(50),
	@Grupo as varchar(50),
	@DtInicial as datetime,
	@DtFinal as datetime
)
as

--set @Grupo = (select cd_pes from pessoa where apelido = @Grupo)
--set @Grupo = (select grupo from grupo where cd_pes_grupo = @Grupo)

	Begin

		Declare @Paridade Table
		(
			Cd_Tp_Moeda Char(3),
			Valor		float
		)

		Insert @paridade
		select cd_tp_moeda,DBO.[FConverterMoeda](cd_tp_moeda,'REL') from tipo_moeda with(nolock)


		Select 
			PP.Apelido Cliente,CTA.num_proc_hia JOB,cast(Nota_Fiscal as varchar(10)) + ref_Acesso Num_NF,
			Emissao,[dbo].[fBusca_TipoDocCliente]('N',CTA.num_proc_hia,1) PO, Nome_Tp_TX Taxa, CTA.dc_hia DC,
			cta.Vlr_org_hia*Valor Valor, Dt_Prev_Pgto_hia Vencimento, convert(decimal,getdate() - convert(datetime,Dt_Prev_Pgto_hia,105)) Atraso 
		from 
			vwcta_Cte CTA  With(nolock)
			--Join vwcliente CLI with(nolock) on CLI.Num_PRoc=cta.num_proc_hia
			Join Pessoa PP with(nolock) on cd_Cred_dev_hia=cd_pes
			Left Join Base_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_acesso=ref_acesso_nf_hia
			Left Join vwcxas CXA With(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_Tp_Tx=cxa.cd_tp_Tx
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.cd_tp_Tx
			Join Pessoa_LLP PLLP with(nolock) on PLLP.cd_pes=cd_Cred_dev_hia
			Join Pessoa GRP with(nolock) on GRP.cd_pes=PLLP.cd_pes_grupo
			Join @Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda
		Where
			cxa.num_lcto is null
			and substring(cta.num_proc_hia,3,3) <> 'JOB' and cta.desp_org_hia='N' and (GRP.apelido like @Grupo or @Grupo='') and (pp.apelido like @Cliente or @Cliente='')
			and convert(datetime,Dt_Prev_Pgto_hia,103)  between @DtInicial and @DtFinal and vlr_org_hia > 00.01
			and PP.cd_tp_ativ <> 'AGT'

	end



GO
