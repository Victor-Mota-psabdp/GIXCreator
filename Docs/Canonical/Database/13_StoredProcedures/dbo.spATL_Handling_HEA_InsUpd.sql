SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Handling_HEA
CREATE procedure  [dbo].[spATL_Handling_HEA_InsUpd]
(
	@Num_Proc	varchar (16),
	@Hand_HEA_1	varchar(300),
	@Hand_HEA_2	varchar(300),
	@Hand_HEA_3	varchar(300)
)
as
	If  exists (select Num_Proc_hea from Handling_HEA where Num_Proc_hea=@Num_Proc)
		Begin
			Update
				Handling_HEA
			Set
				Hand_Hea_1 = @Hand_HEA_1,
				Hand_HEA_2 = @Hand_HEA_2,
				Hand_HEA_3 = @Hand_HEA_3
			Where
				Num_Proc_Hea = @Num_Proc
		end
	Else
		Begin
			Insert Into
				handling_hea
				(
					Num_Proc_Hea,Hand_hea_1,Hand_hea_2,Hand_hea_3
				)
			Values
				(
					@Num_Proc,@Hand_hea_1,@Hand_hea_2,@Hand_hea_3
				)
		End



GO
