SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_PO_HIM_InsUpd] 
(			
	@ID_PO_HIM int,
	@Numero_PO_HIM Varchar(80),
	@Data_PO_HIM Datetime,
	@Num_Proc_HIM VarChar(16),
	@Id_DC	int,
	@Cd_Usuario	varchar(10)
)

AS

BEGIN TRANSACTION	

	--Qdo for ID_DC = 10 (Nota Fiscal)
	IF (@Id_DC = 10) and (len(@Numero_PO_him) < 10)
		Begin
			set @Numero_PO_him = right('000000000' + @Numero_PO_him, 10)
		End

	Declare @ID Int

	set @ID_PO_HIM = (select ID_PO_HIM from PO_HIM With(nolock) where ID_DC=@ID_DC and Num_Proc_HIM=@Num_Proc_HIM and Numero_PO_HIM=@Numero_PO_HIM)

	if @ID_PO_him is not null
		BEGIN
			UPDATE
				PO_him
			SET
				Data_PO_HIM = @Data_PO_him,
				Numero_PO_HIM = @Numero_PO_him,
				ID_DC = @Id_DC,
				cd_usuario = @Cd_Usuario,
				dt_ins = getdate()
			WHERE
				id_po_him = @ID_PO_him and Num_Proc_HIM = @Num_Proc_him
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_him),0)+1 from po_him where Num_Proc_him=@Num_Proc_him )
			INSERT INTO
				PO_him
				(
					Num_Proc_him,ID_PO_him,Numero_PO_him,Data_PO_him,Id_DC,cd_usuario,dt_ins
				)
			VALUES
				(
					@Num_Proc_him,@ID,@Numero_PO_him,@Data_PO_him,@Id_DC,@Cd_Usuario, getdate()
				)
-----Caso D.I. inserir no historico
			If @Id_dc = 5
				Begin
					declare @Agora	datetime
					declare @Descr	varchar(200)

					set @Agora = (select getdate())
					set @Descr = ('Registro da D.I. dia: ' + convert(varchar(10), @Data_PO_him, 103)  + ', Previsão de Parametrização dia: ' + convert(varchar(10), @Data_PO_him + 1, 103) + '. Gerado por ATL System.')
					exec dbo.spHistG_InsUPD
								@Num_Proc_him,
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
