SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_PO_HIO_InsUpd] 
(			
	@ID_PO_HIO int,
	@Numero_PO_HIO Varchar(80),
	@Data_PO_HIO Datetime,
	@Num_Proc_HIO VarChar(16),
	@Id_DC	int,
	@Cd_Usuario	varchar(10)
)

AS

BEGIN TRANSACTION	

	--Qdo for ID_DC = 10 (Nota Fiscal)
	IF (@Id_DC = 10) and (len(@Numero_PO_HIO) < 10)
		Begin
			set @Numero_PO_HIO = right('000000000' + @Numero_PO_HIO, 10)
		End

	Declare @ID Int

	set @ID_PO_HIO = (select ID_PO_HIO from PO_HIO With(nolock) where ID_DC=@ID_DC and Num_Proc_HIO=@Num_Proc_HIO and Numero_PO_HIO=@Numero_PO_HIO)

	if @ID_PO_HIO is not null
		BEGIN
			UPDATE
				PO_HIO
			SET
				Data_PO_HIO = @Data_PO_HIO,
				Numero_PO_HIO = @Numero_PO_HIO,
				ID_DC = @Id_DC,
				cd_usuario = @Cd_Usuario,
				dt_ins = getdate()
			WHERE
				id_po_HIO = @ID_PO_HIO and Num_Proc_HIO = @Num_Proc_HIO
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc_HIO )
			INSERT INTO
				PO_HIO
				(
					Num_Proc_HIO,ID_PO_HIO,Numero_PO_HIO,Data_PO_HIO,Id_DC,cd_usuario,dt_ins
				)
			VALUES
				(
					@Num_Proc_HIO,@ID,@Numero_PO_HIO,@Data_PO_HIO,@Id_DC,@Cd_Usuario, getdate()
				)
-----Caso D.I. inserir no historico
			If @Id_dc = 5
				Begin
					declare @Agora	datetime
					declare @Descr	varchar(200)

					set @Agora = (select getdate())
					set @Descr = ('Registro da D.I. dia: ' + convert(varchar(10), @Data_PO_HIO, 103)  + ', Previsão de Parametrização dia: ' + convert(varchar(10), @Data_PO_HIO + 1, 103) + '. Gerado por ATL System.')
					exec dbo.spHistG_InsUPD
								@Num_Proc_HIO,
								Null,
								Null,
								'CHB Historico',
								@Descr,
								@Agora,
								Null,
								'ATL System',
								'S',
								'U',
								null
				End
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION

GO
