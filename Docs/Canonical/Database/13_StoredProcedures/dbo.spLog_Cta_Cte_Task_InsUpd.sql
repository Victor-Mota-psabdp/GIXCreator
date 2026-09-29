SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Log_Cta_Cte_Task
Create procedure [dbo].[spLog_Cta_Cte_Task_InsUpd]
(
	@ID_Log							bigint,
	@Dt_Alter						Datetime,
	@Tp_Oper						varchar(1),

	@ID						bigint,
	@Cd_Tp_Tx				varchar(3),
	@Cd_Tp_DC				varchar(1),
	@Cd_Tp_Modal			varchar(2), 
	@Id_Task				int,
	@Id_Pd					int,
	@Cd_Pes_Grupo			varchar(10),
	@Cd_Usuario				varchar(6),
	@Dt_Ins					DateTime,
	@Ativo					bit
)

AS

BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
		BEGIN		    
			IF not exists(select ID_Log from Log_Cta_Cte_Task where ID_Log = @ID_Log)
				begin
					insert into Log_Cta_Cte_Task
					(						
						[Dt_Alter] ,[Tp_Oper] ,
						Cd_Tp_Tx,Cd_Tp_DC,Cd_Tp_Modal, Id_Task,Id_Pd,Cd_Pes_Grupo,Cd_Usuario,Dt_Ins,Ativo
					)
					values
					(			
						Getdate(),@Tp_Oper,
						@Cd_Tp_Tx,@Cd_Tp_DC,@Cd_Tp_Modal, @Id_Task,@Id_Pd,@Cd_Pes_Grupo,@Cd_Usuario,@Dt_Ins,@Ativo
					)
					set @ID_New = @@IDENTITY
				  End
			ELSE
				begin
					UPDATE
						Log_Cta_Cte_Task
					SET
						Cd_Tp_Tx = @Cd_Tp_Tx,
						Cd_Tp_DC=@Cd_Tp_DC,
						Cd_Tp_Modal = @Cd_Tp_Modal, 
						Id_Task= @Id_Task,
						Id_Pd=@Id_Pd,
						Cd_Pes_Grupo=@Cd_Pes_Grupo,
						Cd_Usuario=@Cd_Usuario,
						Ativo = @Ativo	
					WHERE
						ID_Log = @ID_Log
						set @ID_New = @ID_Log									
				 End
			END	

			Select @ID_New as Retorno;	

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	
END

GO
