SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAtualiza_DtDevol_Upd] --'IMSSZ20100105201', '08/02/2010'

(
@Num_Proc_Him		VarChar(16),
@Num_Cont_IM		varchar(15),
@dt_devol_im		varchar(10)
)

AS

declare @Num_Proc	VarChar(16)

		set @Num_Proc = (select top 1 Mas.Num_Proc_MIM from Container_Mas_Imp_Mar Mas
					join House_Imp_Mar Hou	on	hou.num_proc_MIM = Mas.Num_Proc_MIM
					where Hou.num_proc_him = @Num_Proc_Him)

	Update 
		Container_Mas_Imp_Mar
	Set 
		dt_vcto_devol_im = @dt_devol_im,
		dt_devol_im = @dt_devol_im 
	Where 
		num_proc_mim = @Num_proc
		and Num_Cont_IM = @Num_Cont_IM


GO
