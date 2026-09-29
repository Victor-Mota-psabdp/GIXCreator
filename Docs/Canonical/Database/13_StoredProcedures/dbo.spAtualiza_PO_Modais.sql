SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	procedure  [dbo].[spAtualiza_PO_Modais]
	@Num_Proc_Master varchar(14)
as

BEGIN TRANSACTION

	Declare @Numero_PO	Varchar(80)
	Declare @Data_PO	Datetime
	Declare @Num_Proc	VarChar(16)
	Declare @Id_DC			int

	Declare Cur_PO cursor for 

		select Numero_PO, Data_PO, HOU.Num_Proc_HIM, PM.ID_DC from PO_Master PM
		Join House_Imp_Mar HOU on HOU.Num_Proc_MIM = PM.Num_Proc_Master
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC = PM.ID_DC
		where Num_Proc_Master = @Num_Proc_Master and len(Num_Proc_Master) = 14
		and TDC.Replica = 'S' and Numero_PO is not null and rtrim(Numero_PO) <> ''

	open Cur_PO

		Fetch Next From Cur_PO Into @Numero_PO, @Data_PO, @Num_Proc, @Id_DC

		While @@FETCH_STATUS = 0

			Begin
				exec dbo.spPOHIM_InsUpd null,@Numero_PO,@Data_PO,@Num_Proc,@Id_DC
				Fetch Next From Cur_PO Into @Numero_PO, @Data_PO, @Num_Proc, @Id_DC
			end

	close Cur_PO

	deallocate Cur_PO 

	
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	






GO
