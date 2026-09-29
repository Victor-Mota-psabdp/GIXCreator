SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_HELP pEDIDO
CREATE Procedure [dbo].[spATL_Pedido_InsUpd]
(
		@Cd_pedido 		Int,
		@Num_Pedido		Varchar(30),
		@Cd_Buyer		Varchar(10),
		@Cd_Seller		Varchar(10),
		@Incoterm		Varchar(3),
		@cd_modal		Char(1),
		@cd_tp_moeda	Varchar(3),
		@vlr_pedido		float,
		@Dt_Pedido		Datetime,
		@DL_Chegada		Datetime,
		@Obs_PC			VarChar(300),
		@Cd_Pes_CTT		Varchar(50),
		@Cd_Tp_Cont		Varchar(3),
        @Cd_tipo		char(1),
        @Cd_Pais_Org	VARCHAR(3),
		@Cd_Pais_Dst	VARCHAR(3),
		@Status			Varchar(1),	
		@Cd_USERID		varchar(20),
		@Cd_CSRID		Varchar(20),
        @Cd_Grupo		Varchar(10),
        @Num_PO			Varchar(25),
		@Customer_PO	VarChar(50),
		@Payment		varchar(5),
		@Order_Type		Varchar(2),
        @Cd_Consignee 	varchar(10),
		@Selling_SAP	varchar(5),
		@PO_Responsible	Varchar(50),
		@Planta			varchar(10),
        @Cd_Shipper 	varchar(10),
		@new			int output
		-- @Contato		VarChar(50),		
		-- Status_Entrega      Char(1),
        -- Pedido_Retorno      VarChar(10),
        -- Pedido_Invoice_Only VarChar(10),
        -- Cd_Vendor           VarChar(8),  
        -- DN_R                 Char(1),	
		
)
as

BEGIN TRANSACTION
						
		set @CD_PEDIDO = (select top 1 cd_pedido from pedido with(nolock) where 
			num_pedido = @Num_Pedido and cd_grupo = @CD_Grupo)
			
		IF @CD_PEDIDO IS NULL
			BEGIN
				SET @NEW=(SELECT ISNULL(MAX(CD_PEDIDO),0) FROM PEDIDO)+1
				INSERT INTO
					PEDIDO
					(
                        Cd_pedido,Num_Pedido,Cd_Buyer,Cd_Seller,Incoterm,cd_modal,cd_tp_moeda,vlr_pedido,Dt_Pedido,
                        DL_Chegada,Obs_PC,Cd_Pes_CTT,Cd_Tp_Cont,Cd_tipo,Cd_Pais_Org,Cd_Pais_Dst,Status,Cd_USERID,
                        Cd_CSRID,Cd_Grupo,Num_PO,Customer_PO,Payment,Order_Type,Cd_Consignee,Selling_SAP,PO_Responsible,
                        Planta,Cd_Shipper
                    )			
				VALUES
					(
					    @New,@Num_Pedido,@Cd_Buyer,@Cd_Seller,@Incoterm,@cd_modal,@cd_tp_moeda,@vlr_pedido,@Dt_Pedido,
                        @DL_Chegada,@Obs_PC,@Cd_Pes_CTT,@Cd_Tp_Cont,@Cd_tipo,@Cd_Pais_Org, @Cd_Pais_Dst, @Status, @Cd_USERID,
                        @cd_CSRID,@Cd_Grupo,@Num_PO,@Customer_PO,@Payment, @Order_Type,@Cd_Consignee,@Selling_SAP,@PO_Responsible,
                        @Planta,@Cd_Shipper
                    )			
			END
		ELSE
		 	BEGIN
				UPDATE PEDIDO
					SET
						Num_Pedido=@Num_Pedido,Cd_Buyer=@Cd_Buyer,
						Cd_Seller=@Cd_Seller,Incoterm=@Incoterm,
						cd_modal=@cd_modal,cd_tp_moeda=@cd_tp_moeda,
						vlr_pedido=@vlr_pedido,Dt_Pedido=@Dt_Pedido,
						DL_Chegada=@DL_Chegada,Obs_PC=@Obs_PC,
						Cd_Pes_CTT=@Cd_Pes_CTT,cd_tp_cont=@CD_Tp_Cont,
						Cd_tipo=@Cd_tipo,Cd_Pais_Org=@Cd_Pais_Org,
						Cd_Pais_Dst=@Cd_Pais_Dst,Cd_USERID=@Cd_USERID,
						Cd_CSRID=@Cd_CSRID,Cd_Grupo=@Cd_Grupo,			
						Status=@Status,Num_PO = @num_PO,
						Customer_PO=@Customer_PO,Payment=@Payment,
						Order_Type=@Order_Type,Cd_Consignee=@Cd_Consignee,
						Selling_SAP=@Selling_SAP,PO_Responsible = @PO_Responsible,
						Planta = @Planta,Cd_Shipper = @Cd_Shipper			
					WHERE 
						CD_PEDIDO=@CD_PEDIDO
						SET @NEW=@CD_PEDIDO
			  END
	IF @@ERROR <> 0 
		BEGIN 
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION














GO
