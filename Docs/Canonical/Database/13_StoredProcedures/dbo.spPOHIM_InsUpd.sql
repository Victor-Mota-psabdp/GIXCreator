SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
alter table po_him add cd_usuario varchar(10)
alter table po_him add dt_ins datetime
select * from po_him where cd_usuario is NOT null
*/

CREATE       procedure [dbo].[spPOHIM_InsUpd] --null,'999999999999','01-01-2008','IMCSR20080426401',5
			
	@ID_PO_him int,
	@Numero_PO_him Varchar(80),
	@Data_PO_him Datetime,
	@Num_Proc_him VarChar(16),
	@Id_DC	int

AS

BEGIN TRANSACTION

	--Pegar o usuario q inseriu a inf.
	declare @Host varchar(20) --SYSNAME --
	declare @session_id int

	declare @cd_usuario varchar(20)
	set @cd_usuario = (select top 1 cd_usuario from tmpLOG With(nolock) where job=@num_proc_him and host = @Host and session_id = @session_id)

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
				Data_PO_him = @Data_PO_him,
				Numero_PO_him = @Numero_PO_him,
				Id_DC = @Id_DC,
				cd_usuario = @cd_usuario,
				dt_ins = getdate()
			WHERE
				id_po_him = @ID_PO_him and Num_Proc_him = @Num_Proc_him
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_him),0)+1 from po_him where Num_Proc_him=@Num_Proc_him )
			INSERT INTO
				PO_him
				(
					Num_Proc_him,
					ID_PO_him,	
					Numero_PO_him,
					Data_PO_him,
					Id_DC,
					cd_usuario,
					dt_ins
				)
			VALUES
				(
					@Num_Proc_him,
					@ID,
					@Numero_PO_him,
					@Data_PO_him,
					@Id_DC,
					@cd_usuario, 
					getdate()
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
