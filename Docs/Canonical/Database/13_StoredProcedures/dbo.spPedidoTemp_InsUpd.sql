SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spPedidoTemp_InsUpd]

		@Cd_pedido 		Int,
		@Num_Pedido		Varchar(30),
		@Buyer			VarChar(50),
		@Seller			VarChar(50),
		@Num_PO			Varchar(25),
		@Cd_Pais_Dst	varchar(100),--alterado
		@Porto_Dst		varchar(50),
		@Agente			varchar(50),
		@Navio			varchar(50),
		@Tipo_Container	varchar(50),
		@Num_Container	varchar(50),
		@DL_Carga		varchar(50),
		@DL_Draft		varchar(50),
		@ETD			varchar(50),
		@ETA			varchar(50),
		@Produto		varchar(50),
		@Aduana_Saida	varchar(50),
		@Qty			varchar(50),
		@Peso_Liquido_TOT varchar(50),
		@Dt_Pedido		varchar(50),
		@Nome_Tp_Int	varchar(50),
		@Cd_Proc_Cliente	varchar(50),
		@Vlr_Item	varchar(50),
		@Item	varchar(50),
		@Vlr_Frete_Item	varchar(50),
		@Vlr_Total_Item	varchar(50),
		@Incoterm varchar(50)

as

--BEGIN TRANSACTION

		Declare @ID_Tp_Int		int

		set @ID_Tp_Int = (Select ID_Tp_Int from Tipo_Integracao where Nome_Tp_Int = @Nome_Tp_Int)

		IF @CD_PEDIDO IS NULL
			BEGIN
				SET @Cd_pedido=(SELECT ISNULL(MAX(CD_PEDIDO),0)+1 FROM PEDIDO_TEMP)
				INSERT INTO
					PEDIDO_TEMP
					(
					Cd_pedido,
					Num_Pedido,
					Buyer,
					Seller,
					Cd_Pais_Dst,
					Num_PO,
					Porto_Dst,
					Agente,
					Navio,
					Tipo_Container,
					Num_Container,
					DL_Carga,
					DL_Draft,
					ETD,
					ETA,
					Produto,
					Aduana_Saida,
					Qty,
					Peso_Liquido_TOT,
					Dt_Pedido,
					Cd_Proc_Cliente,
					Vlr_Item,
					Item,
					Vlr_Frete_Item,
					Vlr_Total_Item,
					Incoterm,
					ID_Tp_Int,
					Dt_Insert
					)			
				VALUES
					(
					@Cd_pedido,
					@Num_Pedido,
					@Buyer,
					@Seller,
					@Cd_Pais_Dst,
					@Num_PO,
					@Porto_Dst,
					@Agente,
					@Navio,
					@Tipo_Container,
					@Num_Container,
					@DL_Carga,
					@DL_Draft,
					@ETD,
					@ETA,
					@Produto,
					@Aduana_Saida,
					@Qty,
					@Peso_Liquido_TOT,
					@Dt_Pedido,
					@Cd_Proc_Cliente,
					@Vlr_Item,
					@Item,
					@Vlr_Frete_Item,
					@Vlr_Total_Item,
					@Incoterm,
					@ID_Tp_Int,
					GETDATE()
					)			
			END
--	IF @@ERROR <> 0 
--		BEGIN 
--			ROLLBACK TRANSACTION
--			RETURN -1
--		END
--COMMIT TRANSACTION
--















--ALTER Procedure [dbo].[spPedidoTemp_InsUpd]

--		@Cd_pedido 		Int,
--		@Num_Pedido		Varchar(30),
--		@Buyer			VarChar(50),
--		@Seller			VarChar(50),
--		@Num_PO			Varchar(25),
--		@Cd_Pais_Dst varchar(2),
--		@Porto_Dst	varchar(50),
--		@Agente	varchar(50),
--		@Navio	varchar(50),
--		@Tipo_Container	varchar(50),
--		@Num_Container	varchar(50),
--		@DL_Carga	varchar(50),
--		@DL_Draft	varchar(50),
--		@ETD	varchar(50),
--		@ETA	varchar(50),
--		@Produto	varchar(50),
--		@Aduana_Saida	varchar(50),
--		@Qty	varchar(50),
--		@Peso_Liquido_TOT varchar(50),
--		@Dt_Pedido varchar(50),
--		@Nome_Tp_Int	varchar(50),
--		@Cd_Proc_Cliente	varchar(50),
--		@Vlr_Item	varchar(50),
--		@Item	varchar(50),
--		@Vlr_Frete_Item	varchar(50),
--		@Vlr_Total_Item	varchar(50),
--		@Incoterm varchar(50)

--as

----BEGIN TRANSACTION

--		Declare @ID_Tp_Int		int

--		set @ID_Tp_Int = (Select ID_Tp_Int from Tipo_Integracao where Nome_Tp_Int = @Nome_Tp_Int)

--		IF @CD_PEDIDO IS NULL
--			BEGIN
--				SET @Cd_pedido=(SELECT ISNULL(MAX(CD_PEDIDO),0)+1 FROM PEDIDO_TEMP)
--				INSERT INTO
--					PEDIDO_TEMP
--					(
--					Cd_pedido,
--					Num_Pedido,
--					Buyer,
--					Seller,
--					Cd_Pais_Dst,
--					Num_PO,
--					Porto_Dst,
--					Agente,
--					Navio,
--					Tipo_Container,
--					Num_Container,
--					DL_Carga,
--					DL_Draft,
--					ETD,
--					ETA,
--					Produto,
--					Aduana_Saida,
--					Qty,
--					Peso_Liquido_TOT,
--					Dt_Pedido,
--					Cd_Proc_Cliente,
--					Vlr_Item,
--					Item,
--					Vlr_Frete_Item,
--					Vlr_Total_Item,
--					Incoterm,
--					ID_Tp_Int,
--					Dt_Insert
--					)			
--				VALUES
--					(
--					@Cd_pedido,
--					@Num_Pedido,
--					@Buyer,
--					@Seller,
--					@Cd_Pais_Dst,
--					@Num_PO,
--					@Porto_Dst,
--					@Agente,
--					@Navio,
--					@Tipo_Container,
--					@Num_Container,
--					@DL_Carga,
--					@DL_Draft,
--					@ETD,
--					@ETA,
--					@Produto,
--					@Aduana_Saida,
--					@Qty,
--					@Peso_Liquido_TOT,
--					@Dt_Pedido,
--					@Cd_Proc_Cliente,
--					@Vlr_Item,
--					@Item,
--					@Vlr_Frete_Item,
--					@Vlr_Total_Item,
--					@Incoterm,
--					@ID_Tp_Int,
--					GETDATE()
--					)			
--			END
----	IF @@ERROR <> 0 
----		BEGIN 
----			ROLLBACK TRANSACTION
----			RETURN -1
----		END
----COMMIT TRANSACTION
----













GO
