SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Statement_Rel_Renomeado_]
(
	@CredDev varchar(30),
	@dtInicial datetime,
	@dtFinal datetime,
	@AGT bit
)
AS
--	declare @tabTMP table ([BDP Reference] varchar(16), [BL Reference] varchar(50), [Agent Invoice] varchar(50), [Creditor/Debitor] varchar(50), [Charge Name] varchar(30), [Currency] varchar(5), [Date] datetime, [Value] float)
	Begin
--		insert @tabTMP
		select 
			FD.num_proc [BDP Reference],
			isnull(HEA.hawb_hea,isnull(HEM.hawb_hem,isnull(HEO.hawb_heo,isnull(HIA.hawb_hia,isnull(HIM.hawb_him,HIO.hawb_hio))))) + char(10) + char(13) + '' 
			+ isnull(HEA.mawb_hea,isnull(HEM.mawb_hem,isnull(HEO.mawb_heo,isnull(HIA.mawb_hia,isnull(HIM.mawb_him,HIO.mawb_hio))))) [BL Reference], 
			P.nome_raz_soc [Creditor/Debitor],
			TT.nome_tp_tx [Charge Name],
			FD.cd_tp_moeda [Currency],
			F.dt_fatura [Date],
			(case when FD.DC = 'C' then FD.valor_org else FD.valor_org *-1 end) [Value]
		from 
			fatura_arg F
			join fatura_arg_det FD on FD.id_fat = F.id_fat
			join pessoa P on P.cd_pes = F.cd_pes and ((P.cd_tp_ativ = 'AGT' and @AGT = 1) or (P.cd_tp_ativ <> 'AGT' and @AGT = 0))
			left join house_exp_aer HEA on HEA.num_proc_hea = FD.num_proc
			left join house_exp_mar HEM on HEM.num_proc_hem = FD.num_proc
			left join house_exp_out HEO on HEO.num_proc_heo = FD.num_proc
			left join house_imp_aer HIA on HIA.num_proc_hia = FD.num_proc
			left join house_imp_mar HIM on HIM.num_proc_him = FD.num_proc
			left join house_imp_out HIO on HIO.num_proc_hio = FD.num_proc
			join tipo_taxa TT on TT.cd_tp_tx = FD.cd_tp_tx
			left join pgto_rcto_item LA on LA.id_ref = F.id_fat and LA.tipo_item = 'F'
		where 
			dt_fatura between @dtInicial and @dtFinal
			and P.nome_raz_soc like '%' + @CredDev + '%'
--			and LA.num_lcto is NULL
		order by
			[Creditor/Debitor], [Charge Name]
	End


GO
