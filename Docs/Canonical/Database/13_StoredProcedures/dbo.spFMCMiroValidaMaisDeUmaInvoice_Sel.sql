SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spFMCMiroValidaMaisDeUmaInvoice_Sel
	@Num_Proc	Varchar(16)
	
As

Begin

	Declare @QtyInvoices Int
	Declare @Resultado Varchar(3)
	
	Set @Resultado='NO'
	
	if left(@Num_Proc,2)='IM'
		Begin
			Set @QtyInvoices = Isnull((select count(num_proc_Him) from po_him with (nolock) where num_proc_him=@Num_proc and id_dc=2),0)				
		End
	if left(@Num_Proc,2)='IA'
		Begin
			Set @QtyInvoices = Isnull((select count(num_proc_Hia) from po_hia with (nolock) where num_proc_hia=@Num_proc and id_dc=2),0)				
		End
	if left(@Num_Proc,2)='IO'
		Begin
			Set @QtyInvoices = Isnull((select count(num_proc_HIO) from po_hIO with (nolock) where num_proc_hio=@Num_proc and id_dc=2),0)				
		End

		If @QtyInvoices > 1 
			Begin
				if exists(select * from pedido_ship where num_proc=@Num_proc and invoice is null)
					Begin					
						Set @Resultado='YES'					
					End
				Else
					Begin
						Set @Resultado='NO'					
					End									
				
			End
	Select @Resultado Resultado

End
GO
