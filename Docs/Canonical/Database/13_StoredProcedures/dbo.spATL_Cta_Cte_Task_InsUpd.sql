SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Cta_Cte_Task_InsUpd]
(
    @ID           bigint,
	@Cd_Tp_Tx	  varchar(3),
	@Cd_Tp_DC     varchar(1),
	@Cd_Tp_Modal  varchar(2), 
	@Id_Task	  int,
	@Id_Pd		  int,
	@Cd_Pes_Grupo varchar(10),
	@Cd_Usuario   varchar(6),
	@Dt_Ins		  DateTime,
	@Ativo		  bit
)


AS
--Abre a transação 
BEGIN TRAN
--Exceção(try/CATCH)
--Transação
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID from Cta_Cte_Task where ID = @ID)
			Begin
				Update
					Cta_Cte_Task
				set   
					Cd_Tp_Tx = @Cd_Tp_Tx,
					Cd_Tp_DC=@Cd_Tp_DC,
					Cd_Tp_Modal = @Cd_Tp_Modal, 
					Id_Task= @Id_Task,
					Id_Pd=@Id_Pd,
					Cd_Pes_Grupo=@Cd_Pes_Grupo,
					Cd_Usuario=@Cd_Usuario,
					Ativo = @Ativo	
				Where ID = @ID
		        set @ID_NEW = @ID         
			End
		Else
			BEGIN
				Insert into Cta_Cte_Task 
				( 	Cd_Tp_Tx,
					Cd_Tp_DC,
					Cd_Tp_Modal, 
					Id_Task,
					Id_Pd,
					Cd_Pes_Grupo,
					Cd_Usuario,
					Dt_Ins,
					Ativo	
   					)
				Values
				(	@Cd_Tp_Tx,
					@Cd_Tp_DC,
					@Cd_Tp_Modal, 
					@Id_Task,
					@Id_Pd,
					@Cd_Pes_Grupo,
					@Cd_Usuario,
					GETDATE(),
					@Ativo	
				)
				set @ID_New = @@IDENTITY;
			END	
		Select 0 as [erro], @ID_New as Retorno;
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 1 as [erro], ERROR_MESSAGE() as Retorno;
	END CATCH	


GO
