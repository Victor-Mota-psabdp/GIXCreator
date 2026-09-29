SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_RetificacaoDI_Rel 'Grupo ALL','2020-01-01','2020-06-01'
CREATE procedure [dbo].[spATL_RetificacaoDI_Rel](
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
as
select 
	vwH.Num_Proc [BDP Reference],
	PO.Numero_PO [PO Number],
	CNSG.Apelido [Consignee],
	TP28.Dt_Conclusao [Port Entry Date],
	PO.Numero_DI [DI Number],
	vwH.Canal [Channel],
	TC.Nome_Tp_Carga [Cargo Type],
	TP4.Dt_Conclusao [Custons Clearance Date],
	TP7.Dt_Conclusao [Transport. Doc Delivery Date],
	cast(CP.Campo_Dados as Decimal(10,2))[Quantidade Descarregada],
	vwh.Peso_Liquido [Peso Liquido],
	cast((cast(cp.Campo_Dados as float)/vwh.Peso_Liquido -1) as float)*100 [Differenca %]
	
from 
	vwHouse_IMP vwH
	left join vwPO_IMP PO with(nolock) on  vwH.Num_proc = PO.Num_proc
	join Pessoa CNSG with(nolock) on vwH.Cd_Consig=CNSG.Cd_Pes
	left join Tarefas_Processos TP28 with(nolock) on vwH.Num_proc = TP28.Num_Proc and TP28.ID_Task = 28
	left join Tarefas_Processos TP4 with(nolock) on vwH.Num_proc = TP4.Num_Proc and TP4.ID_Task = 4
	left join Tarefas_Processos TP7 with(nolock) on vwH.Num_proc = TP7.Num_Proc and TP7.ID_Task = 7
	join Doc_Anexos DC84 with(nolock) on vwH.Num_Proc = DC84.Num_Proc and DC84.id_DC=84
	Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=vwH.Cd_Consig
	join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	Left Join Campo_Processo CP with(nolock) on vwH.Num_Proc = CP.Num_Proc and CP.Id_Campo=37 and ISNUMERIC(cp.Campo_Dados)=1 
	left Join Tipo_carga TC on TC.Cd_Tp_Carga=vwh.Tp_Carga
	
where  
	TP4.Dt_Conclusao between @DtInicial and @DtFinal 
	and (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')  


OPTION (HASH JOIN)



GO
