SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spBackOrder_Rel]  '%DOW%','2022-01-01','2022-12-31'	
CREATE Procedure [dbo].[spBackOrder_Rel]--[dbo].[spBackOrder_Rel]  '%DOW%','06-01-1998','06-30-2020'	
	(
	
	@Grupo		varchar(50),
	@DtInicial	datetime,
	@DtFinal	datetime
	
	)
	
	as

select 
		Num_Pedido [Order],
		Customer_PO [Customer PO],
		Dt_Pedido [Order Dt],
		PP.Apelido Buyer, 
		S.Apelido Shipper,
		Incoterm,
		cd_tp_moeda [Currency],
		vlr_pedido [Order Value],
		DL_Chegada [PO Request Date],
		PC.Produto_Descr ,
		Nome_Tp_Status_Pedido [Status],
		(Case 
			When Cd_Pais_Org='BR' then 'Export'
			else 'Import'

		end) Modal ,
		Origem.Nome_Pais [Country of Origin],
		Destino.Nome_Pais [Country of Destination],
		P.Cd_tipo + '-' + TP.Nome_Tp_Pedido [Type]
from 
	Pedido P with(nolock)
	Join Pedido_Det PD with(nolock) on PD.Cd_Pedido=P.Cd_pedido 
	Left Join Pedido_Ship ps with(nolock) on pd.cd_pedido =ps.Cd_pedido and pd.Cd_Produto=ps.cd_produto and pd.item=Ps.item and Pd.lote=PS.Lote
	
	Left Join Pessoa PP with(nolock) on pp.Cd_Pes=Cd_Buyer
	left Join Pessoa S with(nolock)  on s.Cd_Pes=Cd_Seller 
	Join Pessoa G with(nolock) on G.Cd_Pes=Cd_Grupo  
	Left Join Tipo_Status_Pedido TS with(nolock) on P.Status=cd_tp_status_pedido 
	
	Join Produto_cliente PC with(nolock) on PC.cd_prod = PD.cd_produto
	Left Join Pais Origem with(nolock) on P.Cd_Pais_Org=Origem.Cd_Pais
	Left Join Pais Destino with(nolock) on P.Cd_Pais_Dst = Destino.cd_pais 
	join Tipo_Pedido TP  with(nolock) on P.Cd_tipo=TP.cd_Tp_Pedido 
where 
	ps.cd_pedido is null  and  g.apelido like @Grupo and Dt_Pedido between @DtInicial and @DtFinal 
	and P.status not in ('E')


GO
