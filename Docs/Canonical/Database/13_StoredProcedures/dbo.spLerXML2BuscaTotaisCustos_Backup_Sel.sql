SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- spLerXML2BuscaTotaisCustos_Sel 'IMCSR201508415BR'
CREATE Procedure [dbo].[spLerXML2BuscaTotaisCustos_Backup_Sel]--'IMSLA201708011BR'

	@Num_Proc Varchar(16)

AS
--Rotina utilizada para puxar os totais de impostos e ajustes valores no Custo_Cliente
--Anderson
--27/06/2014 incluido pra pegar cfop = 35
--24-07-2015 Cadu, incluido o XAM-AFRMM
--14/08/2015 - retirada a regra do CFOP e avisado pra marcia por email - CADU, 2/12/2015 - sumiu isso coloquei o 39 no cfop

/*
select 
	sum(FOB) Fob, sum(fretecollect) Frete,sum(acrescimos) THC,sum(vl_icms) ICMS,
	sum(vl_imposto_cofins) Cofins, sum(vl_imposto_pis) PIS, sum(vl_ipi) IPI, sum(vl_ii) II,
	sum(vlr_siscomex) Sicomex, sum(vlr_seguro) Seguro, NC.num_proc,NDD.cd_produto,sum(vlr_frete) FreteDI--,sum(DItem.Valor_Antidump) ValorAntidump
from notA_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
	--left Join DI_ITEM_BR DItem with(nolock) on  NC.Num_Proc=DITEM.Num_Proc and NDD.ID_Item = DITEM.Item and  NDD.cd_produto =DITEM.cd_produto
Where
	NC.Num_Proc=@Num_Proc 
	and quantidade <> 0 --and acrescimos <> 0
	and (left(replace(cfop,'.',''),2) in ('31','35') or substring(@Num_Proc,3,3) in ('CSR','ROB','STR'))
Group by NC.Num_Proc, NDD.cd_produto
*/
SET NOCOUNT ON
Declare @Tab table(
			Num_proc varchar(16),
			Cd_Produto varchar(10),
			Valor_Antidump float
)
insert @Tab
select Num_proc,Cd_Produto,sum(Valor_Antidump) from DI_ITEM_BR where num_proc = @Num_Proc group by Num_proc,Cd_Produto
--and Valor_Antidump <> 0 		

--if exists(Select Num_proc from @Tab where num_proc = @Num_Proc)
	Begin
		select 
			sum(FOB) Fob, sum(fretecollect) Frete,sum(acrescimos) THC,sum(vl_icms) ICMS,
			sum(vl_imposto_cofins) Cofins, sum(vl_imposto_pis) PIS, sum(vl_ipi) IPI, sum(vl_ii) II,
			sum(vlr_siscomex) Sicomex, sum(vlr_seguro) Seguro, NC.num_proc,NDD.cd_produto,
			sum(vlr_frete) FreteDI,
			isnull(DItem.Valor_Antidump,0) ValorAntidump,
			cast([dbo].[fBuscaPorcentagem_CdProduto] (NC.num_proc,NDD.cd_produto)* CP.valor as decimal(10,2)) AFRMM
		from notA_cliente NC with(nolock)
			Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
			left Join @Tab DItem on  NC.Num_Proc=DITEM.Num_Proc and  NDD.cd_produto =DITEM.cd_produto
			left join Custo_Processo CP with(nolock) on CP.Num_Proc = NC.Num_Proc and Cd_Tp_Tx = 'XAM'
		Where 
			NC.Num_Proc = @Num_Proc ---and Nc.cd_Cliente = @Cd_Cliente
			and quantidade <> 0 --and acrescimos <> 0
			and (
				left(replace(cfop,'.',''),2) in ('31','35','39') 
				or substring(@Num_Proc,3,3) in ('CSR','ROB','STR') 
				or (SUBSTRING(@Num_Proc,1,2) = 'IA' and substring(@Num_Proc,3,3) not in ('FMC'))
				)
		Group by NC.Num_Proc, NDD.cd_produto, DItem.Num_Proc, DItem.cd_produto,CP.valor,DItem.Valor_Antidump
	end
--else
--	begin
--		select 
--			sum(FOB) Fob, sum(fretecollect) Frete,sum(acrescimos) THC,sum(vl_icms) ICMS,
--			sum(vl_imposto_cofins) Cofins, sum(vl_imposto_pis) PIS, sum(vl_ipi) IPI, sum(vl_ii) II,
--			sum(vlr_siscomex) Sicomex, sum(vlr_seguro) Seguro, NC.num_proc,NDD.cd_produto,
--			sum(vlr_frete) FreteDI,0 ValorAntidump,
--			cast([dbo].[fBuscaPorcentagem_CdProduto] (NC.num_proc,NDD.cd_produto)* CP.valor as decimal(10,2)) AFRMM
--		from notA_cliente NC with(nolock)
--			 Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
--			 left join Custo_Processo CP with(nolock) on CP.Num_Proc = NC.Num_Proc and Cd_Tp_Tx = 'XAM'	
--		Where
--			NC.Num_Proc = @Num_Proc ---and Nc.cd_Cliente = @Cd_Cliente
--			and quantidade <> 0 --and acrescimos <> 0
--			--and (left(replace(cfop,'.',''),2) in ('31','35') or substring(@Num_Proc,3,3) in ('CSR','ROB','STR'))
--			and (
--				left(replace(cfop,'.',''),2) in ('31','35','39') 
--				or substring(@Num_Proc,3,3) in ('CSR','ROB','STR') 
--				or (SUBSTRING(@Num_Proc,1,2) = 'IA' and substring(@Num_Proc,3,3) not in ('FMC'))
--				)
--		Group by NC.Num_Proc, NDD.cd_produto,CP.valor
--	end
	
	
	
--select 
--	sum(FOB) Fob, sum(fretecollect) Frete,sum(acrescimos) THC,sum(vl_icms) ICMS,
--	sum(vl_imposto_cofins) Cofins, sum(vl_imposto_pis) PIS, sum(vl_ipi) IPI, sum(vl_ii) II,
--	sum(vlr_siscomex) Sicomex, sum(vlr_seguro) Seguro, num_proc,cd_produto,sum(vlr_frete) FreteDI
--from notA_cliente NC with(nolock)
--	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
--Where
--	Num_Proc=@Num_proc 
--	and quantidade <> 0 --and acrescimos <> 0
--	and (left(replace(cfop,'.',''),2) in ('31','35') or substring(@Num_Proc,3,3) in ('CSR','ROB','STR'))
--Group by Num_Proc, cd_produto






GO
