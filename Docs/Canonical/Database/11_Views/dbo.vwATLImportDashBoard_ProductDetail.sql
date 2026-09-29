SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwATLImportDashBoard_ProductDetail]
as

select 
		H.Num_Proc [BDP Ref.],
		PC.Produto_Descr [Product Description],
		TP216.Dt_Conclusao [Protocol MAPA IN26 – Date],
		cast(dbo.fBusca_TipoDocCliente('D',H.Num_Proc,23) as datetime)  [LI Date],
		(Case when P.Cd_Tipo = '2' and Left(H.Num_Proc, 1) = 'I' then 'Third' else    
		Case when P.Cd_Tipo = '2' and Left(H.Num_Proc, 1) = 'E' then 'Indent' else    
		Case when P.Cd_Tipo = '3' then 'Inter-company' else    
		Case when P.Cd_Tipo = '4' then 'Samples' else 'Samples' End End End End)[Order Type]
From
	vwHouse_Imp H
	Left Join Tarefas_processos TP216 with(nolock) on H.Num_Proc=TP216.Num_Proc and TP216.ID_Task=216
	Left Join Tarefas_processos TP4 with(nolock) on H.Num_Proc=TP4.Num_Proc and TP4.ID_Task=4
	Left Join Pedido_Ship PS with(nolock) on h.Num_Proc=PS.num_proc
	left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido    

	Left join Produto_Cliente PC with(nolock) on PC.cd_prod=ps.cd_produto 
where
	(
		convert(datetime,h.Dt_Emis,105) >= getdate()-545
		or
		Tp4.Dt_conclusao >=getdate()-545
	)

	-- Alessandra 31/06/2021 - Status 8 devem ser incluidos na busca, segundo solicitação da "Luciana Regina"
	-- E-mail assunto: "BDP Support Ticket#100-278748 with a priority of 4 - Low Assigned to Group Atlantis Development"
	--and h.ID_Status not in (9,8,7)
	and h.ID_Status not in (9,7)

GO
