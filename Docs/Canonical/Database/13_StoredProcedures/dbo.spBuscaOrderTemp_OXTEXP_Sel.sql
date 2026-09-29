SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBuscaOrderTemp_OXTEXP_Sel] (
	@cd_PedidoTemp int	
)
as
Declare @Nome_Pais_Destino varchar(50)
Declare @Seller varchar(50)
Declare @Cd_Pedido int
Declare @Num_PedidoTemp varchar(50)
Declare @Incoterm varchar(50)
Declare @Vlr_Pedido float

set @Nome_Pais_Destino = (select  Nome_Pais from Pedido_Temp PT
							join  Pais P on PT.Cd_Pais_Dst = P.nome_pais_pt
							where Cd_pedido = @cd_PedidoTemp)
--set @Nome_Pais_Destino = (select top 1 PS.Nome_Pais from Pedido_Temp PT
--						join Localidade LC on LC.Nome_Local = (select Top 1 replace(item,'''','') from dbo.fSplit(PT.Porto_Dst ,'('))
--						join Pais PS on LC.Cd_Pais = PS.Cd_Pais
--						where PT.cd_pedido = 1)
set @Num_PedidoTemp = (select Num_pedido from Pedido_Temp where Cd_pedido = @cd_PedidoTemp)
--print @Num_PedidoTemp
set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido where Num_Pedido = @Num_PedidoTemp and Cd_Grupo = 'P21128')
--print @Cd_Pedido
--set @Seller = (select SUBSTRING(Seller,1,6) from Pedido_Temp where Cd_pedido = @cd_PedidoTemp)
set @Seller = (select Seller from Pedido_Temp where Cd_pedido = @cd_PedidoTemp)
set @Seller = (select  top 1 PS.apelido from Pessoa PS
				join Pessoa_LLP PL on PS.Cd_Pes = PL.Cd_Pes and Cd_Pes_Grupo = 'P21128'
				where PL.Cd_Planta = @Seller)
set @Incoterm = (select SUBSTRING(Incoterm,1,3) from Pedido_Temp where Cd_pedido = @cd_PedidoTemp)
set @Vlr_Pedido = (select ISNULL(vlr_pedido,0) from Pedido where Cd_pedido = @Cd_Pedido)
if @Vlr_Pedido is NULL
begin
	set @Vlr_Pedido = 0
	end
print @Vlr_Pedido
select 
		@Cd_Pedido Cd_Pedido,
		Num_Pedido,
		' 'Buyer,
		@Seller Seller,
		@Incoterm Incoterm,
		--' '
		(CASE 
			when [Tipo_Container]In ('20 FLC Container','40 FLC Container','ISOTANQUE','20 FCL CONTAINER','40 FCL CONTAINER','A GRANEL',
			'FLEXITANK','LCL (LESS THAN CNTR)') Then 'O'
		ELSE( CASE 
			when [Tipo_Container] in ('CAMINHÃO EMBALADO','CAMINHÃO GRANEL') Then 'R' 
		ELSE ' ' 
		END)END) Cd_Modal,
		'USD'Cd_Tp_Moeda,
		--Replace (Vlr_Total_Item,',','.') + @Vlr_Pedido Vlr_Pedido,
		Replace (Vlr_Total_Item,',','.') Vlr_Pedido,
		isnull(Dt_Pedido,CONVERT(varchar,GETDATE(),103))  Dt_Pedido,
		DL_Chegada,
		'Integração - Oxiteno ' + CONVERT(varchar,GETDATE(),103) Obs_PC,
		Cd_Pes_CTT,
		Cd_Tp_Cont,
		NULL Contato,
		'3' Cd_Tipo,
		'BRAZIL' Nome_Pais_Origem,
		@Nome_Pais_Destino Nome_Pais_Destino,
		'O' Status,
		Cd_USERID,
		Cd_CSRID,
		'GRUPO OXITENO'Grupo,
		--'P21128' Grupo,
		Num_PO,
		--Num_Pedido Customer_PO,
		Num_PO Customer_PO,
		Payment,
		Order_Type,
		NULL Consignee,
		Selling_SAP,
		PO_Responsible,
		Planta,
		@Seller Shipper
from Pedido_Temp
--join Tipo_Integracao TI on PT.ID_Tp_Int = TI.ID_Tp_Int
where Cd_pedido = @Cd_PedidoTemp





----select * from Pedido_temp
----select * from  Pedido where num_pedido = '29572'
----sp_help Pedido
----select * from Pessoa
----[spBuscaOrderTemp_OXTEXP_Sel] "1"
----incluido o getdate() na dt do pedido - cadu -27-07-2015
--ALTER procedure [dbo].[spBuscaOrderTemp_OXTEXP_Sel] (
--	@cd_PedidoTemp int	
--)
--as
--Declare @Nome_Pais_Destino varchar(50)
--Declare @Seller varchar(50)
--Declare @Cd_Pedido int
--Declare @Num_PedidoTemp varchar(50)
--Declare @Incoterm varchar(50)
--Declare @Vlr_Pedido float

--set @Nome_Pais_Destino = (select  Nome_Pais from Pedido_Temp PT
--							join  Pais P on PT.Cd_Pais_Dst = P.Cd_Pais
--							where Cd_pedido = @cd_PedidoTemp)
----set @Nome_Pais_Destino = (select top 1 PS.Nome_Pais from Pedido_Temp PT
----						join Localidade LC on LC.Nome_Local = (select Top 1 replace(item,'''','') from dbo.fSplit(PT.Porto_Dst ,'('))
----						join Pais PS on LC.Cd_Pais = PS.Cd_Pais
----						where PT.cd_pedido = 1)
--set @Num_PedidoTemp = (select Num_pedido from Pedido_Temp where Cd_pedido = @cd_PedidoTemp)
--print @Num_PedidoTemp
--set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido where Num_Pedido = @Num_PedidoTemp and Cd_Grupo = 'P21128')
--print @Cd_Pedido
--set @Seller = (select SUBSTRING(Seller,1,6) from Pedido_Temp where Cd_pedido = @cd_PedidoTemp)
--set @Seller = (select  top 1 PS.apelido from Pessoa PS
--				join Pessoa_LLP PL on PS.Cd_Pes = PL.Cd_Pes and Cd_Pes_Grupo = 'P21128'
--				where PL.Cd_Planta = @Seller)
--set @Incoterm = (select SUBSTRING(Incoterm,1,3) from Pedido_Temp where Cd_pedido = @cd_PedidoTemp)
--set @Vlr_Pedido = (select ISNULL(vlr_pedido,0) from Pedido where Cd_pedido = @Cd_Pedido)
--if @Vlr_Pedido is NULL
--begin
--	set @Vlr_Pedido = 0
--	end
--print @Vlr_Pedido
--select 
--		@Cd_Pedido Cd_Pedido,
--		Num_Pedido,
--		' 'Buyer,
--		@Seller Seller,
--		@Incoterm Incoterm,
--		--' ' 
--		(CASE 
--			when [Tipo_Container]In ('ISOTANQUE','20 FCL CONTAINER','40 FCL CONTAINER','A GRANEL','FLEXITANK','LCL (LESS THAN CNTR)') Then 'O'
--		ELSE( CASE 
--			when [Tipo_Container] in ('CAMINHÃO EMBALADO','CAMINHÃO GRANEL') Then 'R' 
--		ELSE ' ' 
--		END)END) Cd_Modal,
--		'USD'Cd_Tp_Moeda,
--		Replace (Vlr_Total_Item,',','.') + @Vlr_Pedido Vlr_Pedido,
--		isnull(Dt_Pedido,CONVERT(varchar,GETDATE(),103))  Dt_Pedido,
--		DL_Chegada,
--		'Integração - Oxiteno ' + CONVERT(varchar,GETDATE(),103) Obs_PC,
--		Cd_Pes_CTT,
--		Cd_Tp_Cont,
--		NULL Contato,
--		'3' Cd_Tipo,
--		'BRAZIL' Nome_Pais_Origem,
--		@Nome_Pais_Destino Nome_Pais_Destino,
--		'O' Status,
--		Cd_USERID,
--		Cd_CSRID,
--		'GRUPO OXITENO'Grupo,
--		--'P21128' Grupo,
--		Num_PO,
--		Num_Pedido Customer_PO,
--		Payment,
--		Order_Type,
--		NULL Consignee,
--		Selling_SAP,
--		PO_Responsible,
--		Planta
--from Pedido_Temp
----join Tipo_Integracao TI on PT.ID_Tp_Int = TI.ID_Tp_Int
--where Cd_pedido = @Cd_PedidoTemp


GO
