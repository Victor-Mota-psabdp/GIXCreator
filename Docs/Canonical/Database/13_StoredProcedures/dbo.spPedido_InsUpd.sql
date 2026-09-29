SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
SELECT * FROM PAIS WHERE NOME_PAIS like 'United Arab Emira'
select len('United Arab Emirates') 20
select 256-273 = 17
select 236-253
*/

CREATE Procedure [dbo].[spPedido_InsUpd]

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
		@Selling_SAP	varchar(8),
		@PO_Responsible	Varchar(50),
		@Planta			varchar(10),
		@Shipper		varchar(50),
		@new			int output

as

BEGIN TRANSACTION
		DECLARE @CD_BUYER		VARCHAR(10)
		DECLARE @CD_SELLER		VARCHAR(10)
		DECLARE @CD_PAIS_ORG	VARCHAR(3)
		DECLARE @CD_PAIS_DST	VARCHAR(3)
		Declare @Cd_Consignee 	varchar(10)
		Declare @Cd_Grupo		Varchar(10)
		Declare @Cd_Shipper 	varchar(10)
		
		--IF EXISTS(select Cd_pedido from Pedido where num_pedido = @Num_Pedido and Dt_Pedido > GETDATE() - 360)
		--	BEGIN
		--		insert log_pedido
		--		(cd_pedido,dt_ins,num_pedido,dt_pedido)
		--		values
		--		(@CD_PEDIDO, GETDATE(), @Num_Pedido, @Dt_Pedido)
	
		--		RETURN -2

		--	END

		SET @CD_BUYER=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@BUYER)
		SET @CD_SELLER=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@SELLER)
		SET @CD_PAIS_ORG=(SELECT CD_PAIS FROM PAIS WHERE NOME_PAIS=@NOME_PAIS_ORIGEM)
		--incluido pois na integração da dow o nome do destino tem apenas 17 caracteres
		if LEN(@NOME_PAIS_DESTINO)>= 17			
			SET @CD_PAIS_DST=(SELECT CD_PAIS FROM PAIS WHERE NOME_PAIS=@NOME_PAIS_DESTINO)
		else
			SET @CD_PAIS_DST=(SELECT top 1 CD_PAIS FROM PAIS WHERE NOME_PAIS like @NOME_PAIS_DESTINO + '%')
				
		SET @Cd_Consignee=(SELECT CD_PES FROM PESSOA WHERE APELIDO=@Consignee)
		SET @Cd_Shipper=(SELECT CD_PES FROM PESSOA with(nolock) WHERE APELIDO=@Shipper)
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
					Planta,
					Cd_Shipper
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
					@Planta,
					@Cd_Shipper
					)			
			END
		ELSE
		 	BEGIN
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
						Planta = @Planta,
						Cd_Shipper = @Cd_Shipper
			
					WHERE 
						CD_PEDIDO=@CD_PEDIDO
			  END
	IF @@ERROR <> 0 
		BEGIN 
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION














GO
