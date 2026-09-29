SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spExchangeCtaCte_Upd]
	@ID bigint,@Num_PRoc Varchar(16)
AS
SET DEADLOCK_PRIORITY HIGH;
Begin
	Insert exchange_Cta_Cte_SENT(ID,num_proc,dt_envio)
	values (@ID,@Num_PRoc,GETDATE())

End
/*

ELSE
BEGIN

		if LEFT(@num_Proc,2)='IA' 
		begin
			Insert exchange_Cta_Cte_ia(ID,num_proc,dt_envio)
			values (@ID,@Num_PRoc,GETDATE())
			
		end
		if LEFT(@num_Proc,2) not in ('IO','IA','IM','EM') 
			Begin
				update exchange_cta_cte set Dt_Envio = getdate() where id=@ID
			End
			
			
		if LEFT(@num_Proc,2)='IO' 
			begin
				Insert exchange_Cta_Cte_io(ID,num_proc,dt_envio)
				values (@ID,@Num_PRoc,GETDATE())
				
			end


		if LEFT(@num_Proc,2)='IM' 
			begin
				Insert exchange_Cta_Cte_IM(ID,num_proc,dt_envio)
				values (@ID,@Num_PRoc,GETDATE())
				
			end
			
			
			
		if LEFT(@num_Proc,2)='EM' 
			begin
				Insert exchange_Cta_Cte_EM(ID,num_proc,dt_envio)
				values (@ID,@Num_PRoc,GETDATE())
				
			end
end

*/
GO
