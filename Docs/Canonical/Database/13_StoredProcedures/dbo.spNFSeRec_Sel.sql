SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--[spNFSeRec_Sel]'A', '413336'
CREATE procedure [dbo].[spNFSeRec_Sel]--'A', '25533'

	@Tipo		char(1),
	@Numero		varchar(12)

as

SET NOCOUNT ON

Declare @TAB Table
		(
			[TX_NF] varchar(50),
			[Taxa] varchar(50),
			[Vlr_Pgto_NF] decimal(18,2),
			[DC] char(1)
		)
insert INTO @TAB
select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_hem) Vlr_Pgto_NF,CC.DC_Hem DC from cta_cte_hou_exp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hem =@Numero and ref_Acesso_nf_hem = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_Hem

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_hea) Vlr_Pgto_NF,CC.DC_Hea DC from cta_cte_hou_exp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hea =@Numero and ref_Acesso_nf_hea = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_Hea

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_heo) Vlr_Pgto_NF,CC.DC_Heo DC from cta_cte_hou_exp_out CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Heo =@Numero and ref_Acesso_nf_heo = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_Heo

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_hia) Vlr_Pgto_NF,CC.DC_Hia DC from cta_cte_hou_imp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hia =@Numero and ref_Acesso_nf_hia = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_Hia

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_him) Vlr_Pgto_NF,CC.DC_Him DC from cta_cte_hou_imp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Him =@Numero and ref_Acesso_nf_him = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_Him

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_hio) Vlr_Pgto_NF,CC.DC_Hio DC from cta_cte_hou_imp_out CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_Hio =@Numero and ref_Acesso_nf_hio = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_Hio

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_mem) Vlr_Pgto_NF,CC.DC_mem DC from cta_cte_mas_exp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mem =@Numero and ref_Acesso_nf_mem = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_mem

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_mea) Vlr_Pgto_NF,CC.DC_mea DC from cta_cte_mas_exp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mea =@Numero and ref_Acesso_nf_mea = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_mea

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_mim) Vlr_Pgto_NF,CC.DC_mim DC from cta_cte_mas_imp_mar CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mim =@Numero and ref_Acesso_nf_mim = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_mim

union

select TX.cd_tp_tx TX_NF, TT.Nome_tp_tx Taxa, sum(CC.Vlr_Pgto_NF_mia) Vlr_Pgto_NF,CC.DC_mia DC from cta_cte_mas_imp_aer CC
left outer join tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
left Outer Join Tipo_Moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
left outer join  pessoa_tx_exc_nf TX on CC.cd_tp_tx=TX.cd_tp_tx 
where  CC.Num_Nf_mia =@Numero and ref_Acesso_nf_mia = @Tipo
group by TX.cd_tp_tx,TT.Nome_tp_tx, CC.DC_mia


order by Taxa

insert INTO @TAB
select NULL TX_NF ,TI.Descr_Imposto Taxa , Valor Vlr_Pgto_NF, NULL DC  from Tipo_Campo_Impostos TI
Join Campo_Impostos CI on TI.Cd_Site = CI.Cd_Site and CI.Id_Imposto = TI.Id_Imposto  
where TI.Cd_Site = @Tipo and CI.Nota_Fiscal = @Numero
order by Taxa

Select * from @TAB
GO
