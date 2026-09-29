SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pProcPO_Sel 
(
@Po		varchar(20) 
)
AS
BEGIN
	SElect distinct num_proc_hea processo from po_hea where numero_po_hea = @Po
	Union 
	SElect distinct num_proc_hem processo from po_hem where numero_po_hem = @Po
	Union 
	Select distinct num_proc_hia processo from po_hia where numero_po_hia = @Po
	Union 
	Select distinct num_proc_him processo from po_him where numero_po_him = @Po
	Union 
	Select distinct num_proc_hio processo from po_hio where numero_po_hio = @Po
	Union 
	Select distinct num_proc_heo processo from po_heo where numero_po_heo = @Po

END

GO
