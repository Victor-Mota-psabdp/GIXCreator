SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_TEUS] --('IMSSZ20080100101')
(
@Num_proc Varchar(16)
)
RETURNS float
AS  
BEGIN
	Declare @NTEUS	float
	Declare @Tipo_Container varchar(30)
	
	set @NTEUS=0
if left(@num_proc,2)='IM'
	SEt @NTEUS=0
	BEGIN
	Declare Container cursor for 
					select cd_tp_cont
						from 
							Container_mas_imp_mar CM with(nolock)
							Join Container_hou_imp_mar CH with(nolock) on CH.num_proc_mim=CM.num_proc_mim and ch.item_cont_im=cm.item_Cont_im
					Where 
							num_proc_him=@Num_proc
		open Container
			Fetch Next From Container Into @Tipo_Container
			While @@FETCH_STATUS = 0
			Begin
				if left(@Tipo_Container,1)='2' or Left(@Tipo_Container,1)='4'
					Begin
/*
						if left(@Tipo_Container,1)='2' 
							Set @NTEUS=@NTEUS + 1
						else
							Set @NTEUS=@NTEUS + 2
*/
                     Set @NTEUS=@NTEUS+(select Qtd_Teus from Tipo_Container with(nolock) where Cd_Tp_Cont = @Tipo_Container)  

					end
				else
					begin
						set @NTEUS=0
					end
				
				Fetch Next From Container Into @Tipo_Container
			end
		close Container
		deallocate Container
	END
	

if left(@num_proc,2)='EM'
	SEt @NTEUS=0
	BEGIN
	Declare Container cursor for 
					select cd_tp_cont
						from 
							Container_mas_exp_mar CM with(nolock)
							Join Container_hou_exp_mar CH with(nolock) on CH.num_proc_mem=CM.num_proc_mem and ch.item_cont_em=cm.item_Cont_em
					Where 
							num_proc_hem=@num_proc
		open Container
			Fetch Next From Container Into @Tipo_Container
			While @@FETCH_STATUS = 0
			Begin
				if left(@Tipo_Container,1)='2' or Left(@Tipo_Container,1)='4'
					Begin
/*
						if left(@Tipo_Container,1)='2'
							Set @NTEUS=@NTEUS + 1
						else
							Set @NTEUS=@NTEUS + 2
*/
                     Set @NTEUS=@NTEUS+(select Qtd_Teus from Tipo_Container with(nolock) where Cd_Tp_Cont = @Tipo_Container)  

					end
				else
					begin
						set @NTEUS=0
					end
				
				Fetch Next From Container Into @Tipo_Container
			end
		close Container
		deallocate Container
	END
	return @NTEUS

	
END
GO
