SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_PO_HIA_InsUpd] 
(			
	@ID_PO_HIA int,
	@Numero_PO_HIA Varchar(80),
	@Data_PO_HIA Datetime,
	@Num_Proc_HIA VarChar(16),
	@Id_DC	int,
	@Cd_Usuario	varchar(10)
)

AS

BEGIN TRANSACTION	

	--Qdo for ID_DC = 10 (Nota Fiscal)
	IF (@Id_DC = 10) and (len(@Numero_PO_HIA) < 10)
		Begin
			set @Numero_PO_HIA = right('000000000' + @Numero_PO_HIA, 10)
		End

	Declare @ID Int

	set @ID_PO_HIA = (select ID_PO_HIA from PO_HIA With(nolock) where ID_DC=@ID_DC and Num_Proc_HIA=@Num_Proc_HIA and Numero_PO_HIA=@Numero_PO_HIA)

	if @ID_PO_HIA is not null
		BEGIN
			UPDATE
				PO_HIA
			SET
				Data_PO_HIA = @Data_PO_HIA,
				Numero_PO_HIA = @Numero_PO_HIA,
				ID_DC = @Id_DC,
				cd_usuario = @Cd_Usuario,
				dt_ins = getdate()
			WHERE
				id_po_HIA = @ID_PO_HIA and Num_Proc_HIA = @Num_Proc_HIA
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc_HIA )
			INSERT INTO
				PO_HIA
				(
					Num_Proc_HIA,ID_PO_HIA,Numero_PO_HIA,Data_PO_HIA,Id_DC,cd_usuario,dt_ins
				)
			VALUES
				(
					@Num_Proc_HIA,@ID,@Numero_PO_HIA,@Data_PO_HIA,@Id_DC,@Cd_Usuario, getdate()
				)
-----Caso D.I. inserir no historico
			If @Id_dc = 5
				Begin
					declare @Agora	datetime
					declare @Descr	varchar(200)

					set @Agora = (select getdate())
					set @Descr = ('Registro da D.I. dia: ' + convert(varchar(10), @Data_PO_HIA, 103)  + ', Previsão de Parametrização dia: ' + convert(varchar(10), @Data_PO_HIA + 1, 103) + '. Gerado por ATL System.')
					exec dbo.spHistG_InsUPD
								@Num_Proc_HIA,
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
