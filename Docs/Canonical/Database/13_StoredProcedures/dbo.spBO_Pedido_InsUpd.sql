SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--esquema pra qdo vier null a planta, pq estava apagando a planta q o user havia incluido antes

CREATE Procedure [dbo].[spBO_Pedido_InsUpd]

		@Cd_pedido 		Int,
		@Num_Pedido		Varchar(30),
		@Buyer			VarChar(50),
		@Seller			VarChar(50),
		@Incoterm		Varchar(3),
		@cd_modal		Char(1),
		@cd_tp_moeda	Varchar(3),
		@vlr_pedido		float,
		@Dt_Pedido		Datetime,
		@DL_Chegada		Datetime,
		@Obs_PC			VarChar(300),
		@Cd_Pes_CTT		Varchar(50),
		@Cd_Tp_Cont		Varchar(3),
		@Contato		VarChar(50),
		@Cd_tipo		int,
		@Nome_Pais_Origem	VarChar(50),
		@Nome_Pais_Destino	VarChar(50),
		@Status			Varchar(1),	
		@Cd_USERID		varchar(20),
		@Cd_CSRID		Varchar(20),
		@Grupo			Varchar(20),
		@Num_PO			Varchar(25),
		@Customer_PO	VarChar(50),
		@Payment		varchar(5),
		@Order_Type		Varchar(2),
		@Consignee		VarChar(30),
		@Selling_SAP	varchar(5),
		@PO_Responsible	Varchar(50),
		@Planta			varchar(10),
		@new			int output

as

BEGIN TRANSACTION
		DECLARE @CD_BUYER		VARCHAR(10)
		DECLARE @CD_SELLER		VARCHAR(10)
		DECLARE @CD_PAIS_ORG	VARCHAR(3)
		DECLARE @CD_PAIS_DST	VARCHAR(3)
		Declare @Cd_Consignee 	varchar(10)
		Declare @Cd_Grupo		Varchar(10)

		SET @CD_BUYER=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@BUYER)
		SET @CD_SELLER=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@SELLER)
		SET @CD_PAIS_ORG=(SELECT CD_PAIS FROM PAIS WHERE NOME_PAIS=@NOME_PAIS_ORIGEM)
		SET @CD_PAIS_DST=(SELECT CD_PAIS FROM PAIS WHERE NOME_PAIS=@NOME_PAIS_DESTINO)
		SET @Cd_Consignee=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@Consignee)
		SET @CD_Grupo=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@Grupo)

		IF @CD_PEDIDO IS NULL
			BEGIN
				SET @NEW=(SELECT ISNULL(MAX(CD_PEDIDO),0) FROM PEDIDO)+1
				INSERT INTO
					PEDIDO
					(
					Cd_pedido,
					Num_Pedido,
					Cd_Buyer,
					Cd_Seller,
					Incoterm,
					cd_modal,
					cd_tp_moeda,
					vlr_pedido,
					Dt_Pedido,
					DL_Chegada,
					Obs_PC,
					Cd_Pes_CTT,
					Cd_Tp_Cont,
					Cd_tipo,
					Cd_Pais_Org,
					Cd_Pais_Dst,
					Status,
					Cd_USERID,
					Cd_CSRID,
					Cd_Grupo,
					Num_PO,
					Customer_PO,
					Payment,
					Order_Type,
					Cd_Consignee,
					Selling_SAP,
					PO_Responsible,
					Planta
					)			
				VALUES
					(
					@New,
					@Num_Pedido,
					@Cd_Buyer,
					@Cd_Seller,
					@Incoterm,
					@cd_modal,
					@cd_tp_moeda,
					@vlr_pedido,
					@Dt_Pedido,
					@DL_Chegada,
					@Obs_PC,
					@Cd_Pes_CTT,
					@Cd_Tp_Cont,
					@Cd_tipo,
					@Cd_Pais_Org, 
					@Cd_Pais_Dst, 
					@Status, 
					@Cd_USERID,
					@cd_CSRID,
					@Cd_Grupo,
					@Num_PO,
					@Customer_PO,
					@Payment, 
					@Order_Type,
					@Cd_Consignee,
					@Selling_SAP,
					@PO_Responsible,
					@Planta
					)			
			END
		ELSE
		 	BEGIN
				if @Planta is null
					Begin				
						UPDATE PEDIDO
							SET
								Num_Pedido=@Num_Pedido,
								Cd_Buyer=@Cd_Buyer,
								Cd_Seller=@Cd_Seller,
								Incoterm=@Incoterm,
								cd_modal=@cd_modal,
								cd_tp_moeda=@cd_tp_moeda,
								vlr_pedido=@vlr_pedido,
								Dt_Pedido=@Dt_Pedido,
								DL_Chegada=@DL_Chegada,
								Obs_PC=@Obs_PC,
								Cd_Pes_CTT=@Cd_Pes_CTT,
								cd_tp_cont=@CD_Tp_Cont,
								Cd_tipo=@Cd_tipo,
								Cd_Pais_Org=@Cd_Pais_Org,
								Cd_Pais_Dst=@Cd_Pais_Dst,
								Cd_USERID=@Cd_USERID,
								Cd_CSRID=@Cd_CSRID,
								Cd_Grupo=@Cd_Grupo,			
								Status=@Status,
								Num_PO = @num_PO,
								Customer_PO=@Customer_PO,
								Payment=@Payment,
								Order_Type=@Order_Type,
								Cd_Consignee=@Cd_Consignee,
								Selling_SAP=@Selling_SAP,
								PO_Responsible = @PO_Responsible
							WHERE 
								CD_PEDIDO=@CD_PEDIDO
						End
					Else
						Begin
							UPDATE PEDIDO
								SET
									Num_Pedido=@Num_Pedido,
									Cd_Buyer=@Cd_Buyer,
									Cd_Seller=@Cd_Seller,
									Incoterm=@Incoterm,
									cd_modal=@cd_modal,
									cd_tp_moeda=@cd_tp_moeda,
									vlr_pedido=@vlr_pedido,
									Dt_Pedido=@Dt_Pedido,
									DL_Chegada=@DL_Chegada,
									Obs_PC=@Obs_PC,
									Cd_Pes_CTT=@Cd_Pes_CTT,
									cd_tp_cont=@CD_Tp_Cont,
									Cd_tipo=@Cd_tipo,
									Cd_Pais_Org=@Cd_Pais_Org,
									Cd_Pais_Dst=@Cd_Pais_Dst,
									Cd_USERID=@Cd_USERID,
									Cd_CSRID=@Cd_CSRID,
									Cd_Grupo=@Cd_Grupo,			
									Status=@Status,
									Num_PO = @num_PO,
									Customer_PO=@Customer_PO,
									Payment=@Payment,
									Order_Type=@Order_Type,
									Cd_Consignee=@Cd_Consignee,
									Selling_SAP=@Selling_SAP,
									PO_Responsible = @PO_Responsible,
									Planta = @Planta
							WHERE 
								CD_PEDIDO=@CD_PEDIDO
						End	
					
			  END
	IF @@ERROR <> 0 
		BEGIN 
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION














GO
