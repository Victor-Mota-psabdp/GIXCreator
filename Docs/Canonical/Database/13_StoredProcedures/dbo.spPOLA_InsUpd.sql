SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPOLA_InsUpd]
			
	@ID_PO_LA int,
	@Numero_PO Varchar(100),
	@Data_PO Datetime,
	@Num_LA VarChar(14),
	@Id_DC	int,
	@Nome_Arquivo Varchar(30),
	@Usuario Varchar(40),
	@Paridade float,
	@Valor float,
	@Gravado float,
	@IVA float,
	@Valor_USD float,
	@Gravado_USD float,
	@IVA_USD float,
	@CAI varchar(50),
	@CAI_Vcto datetime,
		
	@Ing_Brt float,
	@Ing_Brt_USD float,
	@Ret float,
	@Ret_USD float

AS

BEGIN TRANSACTION

Declare @cd_usuario varchar(10) 
Set @Cd_usuario=(select cd_usuario from usuario where nome_usuario=@usuario)

Declare @ID Int

	if exists(select * from PO_LA where id_po_la = @ID_PO_LA and Num_LA = @Num_LA)
		BEGIN
			UPDATE
				PO_LA
			SET
				Data_PO = @Data_PO,
				Numero_PO = @Numero_PO,
				Id_DC = @Id_DC,
				Nome_Arquivo=@Nome_Arquivo,
				cd_usuario=@cd_usuario,
				Dt_Ins = getdate(),
				Valor = @Valor,
				Gravado = @Gravado,
				IVA = @IVA,
				Paridade = @Paridade,
				Valor_USD = @Valor_USD,
				Gravado_USD = @Gravado_USD,
				IVA_USD = @IVA_USD,
				CAI = @CAI,
				CAI_Vcto = @CAI_Vcto,
				
				Ing_Brt = @Ing_Brt,
				Ing_Brt_USD = @Ing_Brt_USD,
				Ret = @Ret,
				Ret_USD = @Ret_USD
			WHERE
				id_po_la = @ID_PO_LA and Num_LA = @Num_LA
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_LA),0)+1 from po_la where Num_LA=@Num_LA)
			INSERT INTO
				PO_LA
				(
					Num_LA,
					ID_PO_LA,
					Numero_PO,
					Data_PO,
					Id_DC,
					Nome_Arquivo,
					Cd_Usuario,
					Dt_Ins,
					Valor,
					Gravado,
					IVA,
					Paridade,
					Valor_USD,
					Gravado_USD,
					IVA_USD,
					CAI,
					CAI_Vcto,
					
					Ing_Brt,
					Ing_Brt_USD,
					Ret,
					Ret_USD
				)
			VALUES
				(
					@Num_LA,
					@ID,
					@Numero_PO,
					@Data_PO,
					@Id_DC,
					@Nome_Arquivo,
					@Cd_Usuario,
					getdate(),
					@Valor,
					@Gravado,
					@IVA,
					@Paridade,
					@Valor_USD,
					@Gravado_USD,
					@IVA_USD,
					@CAI,
					@CAI_Vcto,
					
					@Ing_Brt,
					@Ing_Brt_USD,
					@Ret,
					@Ret_USD
				)

		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	























GO
