SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBDPTransportJay_Rel]--'01-01-2013'
(
@DataInicial datetime
)
as
select distinct
LLP.Num_proc_Lem [BDP JOB Number],
'BRSSZ'[BDP Office],
EX.Cd_Pes [Customer Number],
EX.Apelido [Customer Name],
EX.Apelido [Exporter],
CS.Apelido [Consignee],
PPL.Nome_Pais [Country of Origin],
PL.Nome_Local [Place of Receipt],
ORG.Nome_Local [Port of Load],
DST.Nome_Local [Port of Discharge],
DFinal.Nome_Local [Port of Delivery],
PDF.Nome_Pais [Country Ultimate Destination],
NG.Descr [Commodity],
(Case when TCON.Cd_Smart is NULL Then 'LCL' else TCON.Cd_Smart End ) [Container Size],
(Case when TCON.Cd_Smart is NULL Then 'LCL' else TCON.Nome_Tp_Cont End )[Container Type],
LLP.ATD_Lem[Sail Date],
LLP.ETA_LEM [ETA Date]
 from LLP_Exp_Mar LLP with(nolock)
join house_exp_mar HOU with(nolock) on LLP.num_proc_Lem = HOU.Num_proc_hem and Num_Proc_MEM <> 'JOB'
join Pessoa EX with(nolock) on HOU.Cd_Export_hem = EX.Cd_Pes
--join Pessoa_LLP PLLP on EX.Cd_pes = PLLP.Cd_pes 
join Pessoa CS with(nolock) on HOU.Cd_Consig_hem = CS.Cd_Pes
join Localidade PL with(nolock) on LLP.Cd_Planta_Lem = PL.Cd_Local
join Localidade DFinal with(nolock) on LLP.Cd_DstFinal_Lem = DFinal.Cd_Local
join Pais PDF with(nolock) on DFinal.Cd_Pais = PDF.Cd_Pais
join Localidade ORG with(nolock) on HOU.Cd_Org_Hem = ORG.Cd_Local
join Pais PPL with(nolock) on PL.Cd_Pais = PPL.Cd_Pais
join Localidade DST with(nolock) on HOU.Cd_DST_Hem = DST.Cd_Local and (DST.CD_Pais = 'US' or DST.Pais_Local in('United States','EUA'))
left join Nature_Goods NG with(nolock) on LLP.Num_Proc_LEM = NG.Num_proc
--join Pedido_Ship PS on LLP.Num_proc_lem = PS.Num_proc
--join Produto_cliente PC on Ps.cd_produto = PC.Cd_prod and PLLP.cd_pes_grupo = Pc.cd_Cliente 
--join Tipo_Carga TC on LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga
left join container_hou_exp_mar CTH with(nolock) on LLP.Num_proc_lem = CTH.Num_proc_Hem
left join container_mas_exp_mar CTM with(nolock) on CTH.Num_proc_MEM = CTM.Num_proc_MEM  and CTH.Item_Cont_EM = CTM.Item_Cont_EM 
left join Tipo_Container  TCON with(nolock) on CTM.Cd_Tp_Cont = TCON.Cd_Tp_Cont
where LLP.ETD_LEM = getdate()+3

GO
