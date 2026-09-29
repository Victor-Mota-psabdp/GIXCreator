SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_ImportacaoAndamento_Rel 'Grupo Blue Cube'
	CREATE procedure [dbo].[spATL_ImportacaoAndamento_Rel](
		@Grupo varchar(50)
	
	)
	
	as
	

	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa With(nolock) where apelido=@Grupo)

select 
	HOU.Modal, 
	HOU.Num_Proc [BDP Ref.],
	(case
			when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
			when P.cd_tipo='4' then 'Sample'
	end) [Order Type],  
	(case when substring(HOU.Modal,1,3) = 'Air' then 'LCL' else 
		TC.Nome_Tp_Carga 
		end)[Type of Cargo]
		,
	left(dbo.fBusca_Docs_PO_Modal(HOU.num_proc,1),500) [PO Number],
	Business_Group_Descr  [Business Group],
	Business_Descr  [Business Name],
	PSA.Nome_Raz_Soc [Consignee],
	PSA.Num_CPF_CNPJ,
	(select Nome_Pais from pais with(nolock) where cd_pais = Org.cd_pais) [Country Origin],
	Dst.Nome_Local [Destination],
	
		(case when substring(HOU.Modal,1,3) = 'Air' then CIA.Nome_Cia_Aer else 
		 ARM.Nome_Armador end) [Carrier],
	HOU.Vessel [Vessel],
	PC.cd_Proc_Cliente [Product ID],
	PC.Produto_Descr [Product Description],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'23') [Import License],
	HOU.HAWB [House],
	HOU.ETD [ETD Date],
	HOU.ATD [ATD Date],
	HOU.ETA [ETA Date],
	HOU.ATA [ATA Date],
	T63.Dt_Conclusao [Docs OK to Register - Date],
	T15.Dt_Conclusao [Port Entry Date],
	T21.Dt_Conclusao [BL Payment Date],
	PO.Numero_DI [Entry Number],
	PO.Data_DI [Customs Transmission Date],
	T4.Dt_Conclusao [Customs Clearance Date],
	HOU.Canal [Channel],
	T105.Dt_Conclusao [Inspection MAPA - Date],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10') [NF Number],
	cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,10) as datetime) [NF Date],
	T7.Dt_Conclusao [Transport. Doc Delivery Date],
	dbo.fBusca_HistoricoDescr(HOU.Num_Proc,0,getdate()) [Last Historic],
	[dbo].[fBusca_ListNC](HOU.Num_PRoc) [Reason Code Events],
	case
		when Status_Descricao is not null then cast(TSP.id_status as varchar(2)) + ' - ' + Status_Descricao
		else Null
	End  [Process Status]
from 
vwHouse_Imp HOU with(nolock)
join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
join Tipo_Carga TC with(nolock) on HOU.Tp_Carga = TC.Cd_Tp_Carga
left Join Produto_Cliente PC with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_cliente = @cd_pes_grupo
Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo
Left join DE_PARA_PRODUTO DPP with(nolock) on PC.cd_Proc_Cliente = DPP.GMID and DPP.cd_cliente = @cd_pes_grupo
left join Pessoa PSA with(nolock) on HOU.Cd_Consig = PSA.Cd_Pes
left Join Localidade Org with(nolock) on hou.cd_org=Org.cd_local
left Join Localidade Dst with(nolock) on cd_dst=DSt.cd_local
left Join Armador ARM with(nolock) on HOU.Cd_Armador = ARM.Cd_Armador
left Join vwPO_Imp PO with(nolock) on HOU.Num_Proc = PO.Num_Proc
left join tarefas_processos T63 with(nolock) on T63.num_proc=HOU.num_proc and T63.id_task = 63
left join tarefas_processos T15 with(nolock) on T15.num_proc=HOU.num_proc and T15.id_task = 15
left join tarefas_processos T21 with(nolock) on T21.num_proc=HOU.num_proc and T21.id_task = 21
left join tarefas_processos T4 with(nolock) on T4.num_proc=HOU.num_proc and T4.id_task = 4
left join tarefas_processos T105 with(nolock) on T105.num_proc=HOU.num_proc and T105.id_task = 105
join tarefas_processos T7 with(nolock) on T7.num_proc=HOU.num_proc and T7.id_task = 7 and (T7.Dt_Conclusao > GETDATE() -2 or T7.Dt_Conclusao is null)
Left Join Tipo_Status_Processo TSP with(nolock) on HOU.id_status=TSP.id_Status
Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=HOU.cd_armador
where TSP.id_status <> '9' and PO.Numero_Customer_PO <> 'CANCELLED' and convert(datetime,HOU.Dt_Emis,105) >= GETDATE() -180  


GO
