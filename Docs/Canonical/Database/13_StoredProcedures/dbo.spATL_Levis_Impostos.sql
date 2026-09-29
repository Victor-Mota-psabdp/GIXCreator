SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Levis_Impostos] --[spATL_Levis_Impostos]'GRUPO LEVIS','215-01-01','215-02-09'

	@Grupo varchar(30),
	@DtInicial Datetime,
	@DtFinal Datetime
as
declare @cd_pes_grupo varchar(10)
set @cd_pes_grupo = (select top 1 cd_pes from pessoa where Desat_pes = 'N' and apelido = @Grupo)

if @cd_pes_grupo is not NULL
	begin
		set @Grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
	end

select
PS.Num_Proc [JOB],
P.Num_Pedido [PROCESSO],
isnull(DI.Quantidade,PS.Qty) [QUANTIDADE],
PD.Qtde_Embal [QUANTIDADE DE CAIXAS],
HIM.Cd_Tp_Oper [INCOTERM],
'SEA' [MODAL],
DI.PesoBruto [QUANTIDADE DE KG],
dbo.fBusca_Containers_TP (HIM.Num_Proc_HIM) [VOLUMES (TIPO CONTAINER)],
TC.Nome_Tp_Carga [LCL ou FCL],
PO.Numero_PO_HIM [NÚMERO DI],
LOC.Nome_Local [PAIS DE ORIGEM],
HIM.HAWB_HIM [BL / AWB],
CONVERT(VARCHAR(9), LIM.ATA_Lim,6) [DATA DE CHEGADA],
CONVERT(VARCHAR(9), TP4.Dt_Conclusao,6) [DATA DESEMBARAÇO],
LIM.Canal_Lim [CANAL],
HIM.Cd_Tp_Moeda [MOEDA],
DI.Taxa_siscomex [TAXA UTILIZADA],
DI.FOB_USD [F.O.B. - moeda],
DI.FOB_Reais [F.O.B. - R$],
DI.Frete_Moeda_Prepaid [FRETE INTERNACIONAL (Prepaid)],
DI.Frete_Moeda_Collect [FRETE INTERNACIONAL (Collect)],
DI.Frete_Reais [FRETE INTERNACIONAL  - R$],
DI.FOB_Reais + DI.Seguro_Reais + DI.Frete_Reais [C.I.F. - R$],
DI.Valor_II [I.I.],
DI.Valor_IPI [I.P.I.],
DI.Valor_ICMS [ICMS],
DI.Valor_PIS [PIS-PASEP],
DI.Valor_Cofins [COFINS],
cd_Proc_Cliente 

from Pedido P
Join Pedido_Ship PS				With(nolock)on P.Cd_pedido = PS.cd_pedido
Join Pedido_Det PD				With(nolock)on PS.cd_pedido = PD.Cd_Pedido 
Join House_Imp_Mar HIM			With(nolock)on PS.Num_Proc = HIM.Num_Proc_HIM
Join LLP_Imp_Mar LIM			With(nolock)on HIM.Num_Proc_HIM = LIM.Num_Proc_LIM
Join Tipo_Carga TC				With(nolock)on LIM.Cd_Tp_Carga = TC.Cd_Tp_Carga
Left Join PO_HIM PO				With(nolock)on HIM.Num_Proc_HIM = PO.Num_Proc_HIM and ID_DC = '5'
Join Localidade LOC				With(nolock)on HIM.Cd_Org_HIM = LOC.Cd_Local
Join Tarefas_Processos TP4		With(nolock) on HIM.Num_Proc_HIM = TP4.Num_Proc and TP4.ID_Task = '4'
Left join DI_Item_BR DI			with(nolock) on PS.Num_Proc = DI.Num_Proc and PS.cd_produto = DI.cd_Produto
Join Produto_Cliente PC on PC.cd_prod = PS.cd_produto 
where 	substring(LIM.num_proc_Lim,3,3) in (@Grupo)
	and
	convert(Datetime,TP4.Dt_Conclusao,105) between @DtInicial and @DtFinal and LIM.ID_Status <> 9 
	
Group By

PS.Num_Proc,
P.Num_Pedido,
DI.Quantidade,
PD.Qtde_Embal,
HIM.Cd_Tp_Oper,
DI.PesoBruto,
HIM.Num_Proc_HIM,
TC.Nome_Tp_Carga,
PO.Numero_PO_HIM,
LOC.Nome_Local,
HIM.HAWB_HIM,
LIM.ATA_Lim,
TP4.Dt_Conclusao,
LIM.Canal_Lim,
HIM.Cd_Tp_Moeda,
DI.Taxa_siscomex,
DI.FOB_USD,
DI.FOB_Reais,
DI.Frete_Moeda_Prepaid,
DI.Frete_Moeda_Collect,
DI.Frete_Reais,
DI.FOB_Reais + DI.Seguro_Reais + DI.Frete_Reais,
DI.Valor_II,
DI.Valor_IPI,
DI.Valor_ICMS,
DI.Valor_PIS,
DI.Valor_Cofins,
PS.Qty ,
cd_Proc_Cliente 
GO
